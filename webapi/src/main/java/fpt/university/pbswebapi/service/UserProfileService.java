package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.domain.UserProfile;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.repository.UserProfileRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

import static org.apache.http.entity.ContentType.*;

@Service
public class UserProfileService {
    private final UserProfileRepository userProfileRepository;
    private final FileStore fileStore;

    @Autowired
    public UserProfileService(UserProfileRepository userProfileRepository, FileStore fileStore) {
        this.userProfileRepository = userProfileRepository;
        this.fileStore = fileStore;
    }

    public List<UserProfile> getUserProfiles() {
        return userProfileRepository.getUserProfile();
    }

    public void uploadUserProfileImage(UUID userProfileId, MultipartFile file) {
        if (file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        //fake data - refactor later
        UserProfile user = getUserProfileOrThrow(userProfileId);

        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), user.getUserProfileId());
        String filename = String.format("%s-%s", file.getOriginalFilename(), UUID.randomUUID());
        try {
            fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
            user.setUserProfileImageLink(filename);
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public byte[] downloadUserProfileImage(UUID userProfileId) {
        UserProfile user = getUserProfileOrThrow(userProfileId);
        String path = String.format("%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                user.getUserProfileId(),
                user.getUserProfileImageLink());
        return user.getUserProfileImageLink()
            .map(key -> fileStore.download(path, key))
            .orElse(new byte[0]);
    }

    private UserProfile getUserProfileOrThrow(UUID userProfileId) {
        UserProfile user = userProfileRepository
                .getUserProfile()
                .stream()
                .filter(userProfile -> userProfile.getUserProfileId().equals(userProfileId))
                .findFirst()
                .orElseThrow(() -> new IllegalStateException(String.format("User profile %s not found", userProfileId)));
        return user;
    }
}

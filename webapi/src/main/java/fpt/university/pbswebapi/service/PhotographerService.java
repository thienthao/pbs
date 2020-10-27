package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

import static org.apache.http.entity.ContentType.*;

@Service
public class PhotographerService {
    private final UserRepository phtrRepo;
    private final FileStore fileStore;

    @Autowired
    public PhotographerService(UserRepository phtrRepo, FileStore fileStore) {
        this.phtrRepo = phtrRepo;
        this.fileStore = fileStore;
    }

    public List<User> findAllPhotographers() {
        return phtrRepo.findAllPhotographer(Long.parseLong("2"));
    }

    public List<User> findAllCustomers() {
        return phtrRepo.findAllCustomers(Long.parseLong("1"));
    }


    public String uploadAvatar(String id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "avatar");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(Long.parseLong(id));
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setAvatar("https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/download");
                phtrRepo.save(photographer);
                return "https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public byte[] downloadAvatar(String id) {
        String path = String.format("%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                id);
        return fileStore.download(path, id + "-avatar");
    }

    public User findOne(Long id) {
        Optional<User> photographer = phtrRepo.findById(id);
        if(photographer.isPresent())
            return photographer.get();
        else
            throw new BadRequestException("Photographer not exists");
    }

    @Cacheable("photographers")
    public Page<User> findPhotographersByRating(Pageable paging) {
        return phtrRepo.findPhotographersByRating(paging, Long.parseLong("2"));
    }


    public String fakeAvatar(Long id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "avatar");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(id);
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setAvatar("https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/download");
                phtrRepo.save(photographer);
                return "https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public String uploadCover(String id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "cover");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(Long.parseLong(id));
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setCover("https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/cover/download");
                phtrRepo.save(photographer);
                return "https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/cover/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public byte[] downloadCover(String id) {
        String path = String.format("%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                id);
        return fileStore.download(path, id + "-cover");
    }

    public String fakeCover(Long id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "cover");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(id);
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setCover("https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/cover/download");
                phtrRepo.save(photographer);
                return "https://pbs-webapi.herokuapp.com/api/photographers/" + id + "/cover/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }
}

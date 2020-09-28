package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.domain.Album;
import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.repository.PhotographerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

import static org.apache.http.entity.ContentType.*;

@Service
public class PhotographerService {
    private final PhotographerRepository phtrRepo;
    private final FileStore fileStore;

    @Autowired
    public PhotographerService(PhotographerRepository phtrRepo, FileStore fileStore) {
        this.phtrRepo = phtrRepo;
        this.fileStore = fileStore;
    }

    public List<Photographer> findAll() {
        return phtrRepo.findAll();
    }

    public List<Photographer> findAllByNameContaining(String name) {
        return phtrRepo.findAllByNameContaining(name);
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
        Optional<Photographer> phtrOptional = phtrRepo.findById(Long.parseLong(id));
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                Photographer photographer = phtrOptional.get();
                photographer.setAvatar(fullpath);
                phtrRepo.save(photographer);
                return fullpath;
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

    public Photographer findOne(Long id) {
        Optional<Photographer> photographer = phtrRepo.findById(id);
        if(photographer.isPresent())
            return photographer.get();
        else
            throw new BadRequestException("Photographer not exists");
    }
}

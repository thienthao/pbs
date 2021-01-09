package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.entity.Category;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.apache.http.entity.ContentType.*;

@Service
public class CategoryService {

    private CategoryRepository categoryRepository;
    private FileStore fileStore;

    @Autowired
    public CategoryService(CategoryRepository categoryRepository, FileStore fileStore) {
        this.categoryRepository = categoryRepository;
        this.fileStore = fileStore;
    }

    public Page<Category> getAll(Pageable pageable) {
        return categoryRepository.findAll(pageable);
    }

    public String uploadCategoryIcon(Long id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_SVG.getMimeType(), IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/categories/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "category");

        // save photo and save link to repo
        try {
            fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
//            String fullpath = String.format("%s/%s", path, filename);
            Category category = categoryRepository.getOne(id);
            category.setIconLink("http://194.59.165.195:8080/pbs-webapi/api/categories/" + id + "/download");
            categoryRepository.save(category);
            return "http://194.59.165.195:8080/pbs-webapi/api/categories/" + id + "/download";
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public Category save(Category category) {
        return categoryRepository.save(category);
    }

    public byte[] downloadIcon(String id) {
        String path = String.format("%s/categories/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                id);
        return fileStore.download(path, id + "-category");
    }
}

package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.Category;
import fpt.university.pbswebapi.repository.CategoryRepository;
import fpt.university.pbswebapi.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private CategoryService categoryService;
    private CategoryRepository categoryRepository;

    @Autowired
    public CategoryController(CategoryService categoryService, CategoryRepository categoryRepository) {
        this.categoryService = categoryService;
        this.categoryRepository = categoryRepository;
    }

    @GetMapping
    @Cacheable("categories")
    public ResponseEntity<?> getAll() {
        return new ResponseEntity<>(categoryRepository.findAll(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Category category) {
        return new ResponseEntity<>(categoryService.save(category), HttpStatus.OK);
    }

    @PostMapping("/{id}/upload")
    public ResponseEntity<?> uploadCategoryIcon(@PathVariable Long id,
                                                @RequestParam("file") MultipartFile file) {
        String fullpath = categoryService.uploadCategoryIcon(id, file);
        if(fullpath != null) {
            return new ResponseEntity<>(fullpath, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/{id}/download")
    public @ResponseBody ResponseEntity<byte[]> downloadCategoryIcon(@PathVariable("id") String id) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("image/svg+xml"));
        return new ResponseEntity<byte[]>(categoryService.downloadIcon(id), headers, HttpStatus.OK);
    }

    @GetMapping("/fakeIcon")
    public void fake(@RequestParam("file") MultipartFile file) {
        for(Category category : categoryRepository.findAll()) {
            categoryService.uploadCategoryIcon(category.getId(), file);
        }
    }
}

package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.repository.PhotographerRepository;
import fpt.university.pbswebapi.service.PhotographerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/photographers")
public class PhotographerController {
    private final PhotographerRepository photographerRepository;
    private final PhotographerService phtrService;

    @Autowired
    public PhotographerController(PhotographerRepository photographerRepository, PhotographerService phtrService) {
        this.photographerRepository = photographerRepository;
        this.phtrService = phtrService;
    }

    @GetMapping
    public ResponseEntity<List<Photographer>> findAll() {
        return new ResponseEntity<List<Photographer>>(phtrService.findAll(), HttpStatus.OK);
    }

//    @GetMapping("/{name}")
//    public ResponseEntity<List<Photographer>> findAllByNameContaining(@PathVariable String name) {
//        return new ResponseEntity<List<Photographer>>(phtrService.findAllByNameContaining(name), HttpStatus.OK);
//    }

    @GetMapping("/{id}")
    public ResponseEntity<?> findOne(@PathVariable("id") Long id) {
        return new ResponseEntity<>(phtrService.findOne(id), HttpStatus.OK);
    }

    @PostMapping(value = "/{id}/upload",
                consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> uploadAvatar(@PathVariable("id") String id,
                                          @RequestParam("file") MultipartFile file) {
        //check ptgId
        if(!photographerRepository.findById(Long.parseLong(id)).isPresent())
            throw new BadRequestException("Photographer not exists");
        String fullpath = phtrService.uploadAvatar(id, file);
        if(fullpath != null) {
            return new ResponseEntity<>(fullpath, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/{id}/download",
                produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] downloadAvatar(@PathVariable("id") String id) {
        return phtrService.downloadAvatar(id);
    }
}

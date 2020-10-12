package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.entity.Category;
import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.service.PhotographerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/photographers")
public class PhotographerController {
    private final UserRepository photographerRepository;
    private final ServicePackageRepository packageRepository;
    private final PhotographerService phtrService;

    @Autowired
    public PhotographerController(UserRepository photographerRepository, ServicePackageRepository packageRepository, PhotographerService phtrService) {
        this.photographerRepository = photographerRepository;
        this.packageRepository = packageRepository;
        this.phtrService = phtrService;
    }

    @GetMapping
    public ResponseEntity<List<User>> findAll() {
        return new ResponseEntity<List<User>>(phtrService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/byrating")
    public ResponseEntity<Map<String, Object>> findPhotographersByRatingCount(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<User> photographers = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<User> pageUser = phtrService.findPhotographersByRating(paging);
            photographers = pageUser.getContent();

            Map<String, Object> response = new HashMap<>();
            response.put("users", photographers);
            response.put("currentPage", pageUser.getNumber());
            response.put("totalItems", pageUser.getTotalElements());
            response.put("totalPages", pageUser.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            System.out.println(e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

//    @GetMapping("/{name}")
//    public ResponseEntity<List<Photographer>> findAllByNameContaining(@PathVariable String name) {
//        return new ResponseEntity<List<Photographer>>(phtrService.findAllByNameContaining(name), HttpStatus.OK);
//    }

    @GetMapping("/{id}")
    public ResponseEntity<?> findOne(@PathVariable("id") Long id) {
        return new ResponseEntity<>(DtoMapper.toPhotographerDto(phtrService.findOne(id)), HttpStatus.OK);
    }

    @GetMapping("/{id}/split")
    public ResponseEntity<?> findOneSplited(@PathVariable("id") Long id) {
        return new ResponseEntity<>(DtoMapper.toSplitedPhotographerDto(phtrService.findOne(id)), HttpStatus.OK);
    }

    @GetMapping("/{id}/packages")
    public ResponseEntity<Map<String, Object>> findPackagesByPtgId(
            @PathVariable("id") Long id,
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<ServicePackage> packages = new ArrayList<ServicePackage>();
            Pageable paging = PageRequest.of(page, size);

            Page<ServicePackage> pagePackages;
            if(name == null)
                pagePackages = packageRepository.findServicePackageByPtgId(id, paging);
            else
                pagePackages = packageRepository.findServicePackageByPtgIdAndByNameContaining(name, id, paging);

            packages = pagePackages.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("packages", packages);
            response.put("currentPage", pagePackages.getNumber());
            response.put("totalItems", pagePackages.getTotalElements());
            response.put("totalPages", pagePackages.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
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

    @PostMapping(value = "/{id}/cover/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> uploadCover(@PathVariable("id") String id,
                                          @RequestParam("file") MultipartFile file) {
        //check ptgId
        if(!photographerRepository.findById(Long.parseLong(id)).isPresent())
            throw new BadRequestException("Photographer not exists");
        String fullpath = phtrService.uploadCover(id, file);
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

    @GetMapping(value = "/{id}/cover/download",
            produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] downloadCover(@PathVariable("id") String id) {
        return phtrService.downloadCover(id);
    }

    @GetMapping("/fakeAvatar")
    public void fake(@RequestParam MultipartFile file) {
        for(User user : phtrService.findAll()) {
            phtrService.fakeAvatar(user.getId(), file);
        }
    }
}

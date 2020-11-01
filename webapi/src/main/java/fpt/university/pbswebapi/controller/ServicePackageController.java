package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.ServicePackageDto;
import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import fpt.university.pbswebapi.service.PackageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ServicePackageController {

    @Autowired
    private ServicePackageRepository packageRepository;

    @Autowired
    PackageService packageService;

    public ServicePackageController(ServicePackageRepository packageRepository, PackageService packageService) {
        this.packageRepository = packageRepository;
        this.packageService = packageService;
    }

    @GetMapping("/packages")
    public ResponseEntity<Map<String, Object>> getAllPackages(
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<ServicePackage> packages = new ArrayList<ServicePackage>();
            Pageable paging = PageRequest.of(page, size);

            Page<ServicePackage> pagePackages;
            if(name == null)
                pagePackages = packageRepository.findAll(paging);
            else
                pagePackages = packageRepository.findByNameContaining(name, paging);

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

    @GetMapping("/packages/photographer/{ptgId}/split")
    public ResponseEntity<Map<String, Object>> getAllPackagesByPhotographerIdSplit(
            @PathVariable("ptgId") Long ptgId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<ServicePackage> packages = new ArrayList<ServicePackage>();
            Pageable paging = PageRequest.of(page, size);

            Page<ServicePackage> pagePackages;
            pagePackages = packageRepository.findAllOfPhotographer(ptgId, paging);

            packages = pagePackages.getContent();
            List<ServicePackageDto> packageDtos = new ArrayList<>();
            for (ServicePackage servicePackage : packages) {
                packageDtos.add(DtoMapper.toServicePackageDto(servicePackage));
            }
            Map<String, Object> response = new HashMap<>();
            response.put("package", packageDtos);
            response.put("currentPage", pagePackages.getNumber());
            response.put("totalItems", pagePackages.getTotalElements());
            response.put("totalPages", pagePackages.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/packages")
    public ResponseEntity<ServicePackage> createPackage(@RequestBody ServicePackage servicePackage) {
        // validate
        return new ResponseEntity<>(packageService.createPackage(servicePackage), HttpStatus.OK);
    }

    @DeleteMapping("/packages/{ptgId}/{packageId}")
    public ResponseEntity<?> removePackage(@PathVariable("ptgId") Long ptgId,
                                           @PathVariable("packageId") Long packageId) {
        try {
            return new ResponseEntity<Object>(packageService.removePackage(packageId), HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}

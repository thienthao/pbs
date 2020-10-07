package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class ServicePackageController {

    @Autowired
    private ServicePackageRepository packageRepository;

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
}

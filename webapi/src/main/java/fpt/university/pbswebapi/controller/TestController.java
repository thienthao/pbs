package fpt.university.pbswebapi.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import fpt.university.pbswebapi.dto.AlbumJson;
import fpt.university.pbswebapi.dto.NotiRequest;
import fpt.university.pbswebapi.dto.PackageJson;
import fpt.university.pbswebapi.entity.Album;
import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.AlbumRepository;
import fpt.university.pbswebapi.repository.ServicePackageRepository;
import fpt.university.pbswebapi.service.FCMService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/test")
public class TestController {

    private ServicePackageRepository packageRepository;
    private AlbumRepository albumRepository;
    private FCMService fcmService;

    @Autowired
    public TestController(ServicePackageRepository packageRepository, AlbumRepository albumRepository, FCMService fcmService) {
        this.packageRepository = packageRepository;
        this.albumRepository = albumRepository;
        this.fcmService = fcmService;
    }


    @GetMapping("/all")
    public String allAccess() {
        return "test again for chac chan";
    }

    @PostMapping("/notify")
    public String sendNotification(@RequestBody NotiRequest notiRequest) {
        return fcmService.pushNotification(notiRequest);
    }

    @GetMapping("/packages")
    public ResponseEntity<List<ServicePackage>> getPackage() throws IOException{
        ObjectMapper mapper = new ObjectMapper();
        List<PackageJson> packageJsons = mapper.readValue(new File("D:\\real-playground\\fake-data\\packages-standard.json"), new TypeReference<List<PackageJson>>(){});
        List<ServicePackage> servicePackages = new ArrayList<>();
        for(PackageJson packageJson : packageJsons) {
            servicePackages.add(DtoMapper.toServicePackage(packageJson));
        }
        return new ResponseEntity<>(packageRepository.saveAll(servicePackages), HttpStatus.OK);
    }

    @GetMapping("/albums")
    public ResponseEntity<List<Album>> getAlbum() throws IOException{
        ObjectMapper mapper = new ObjectMapper();
        List<AlbumJson> albumJsons = mapper.readValue(new File("D:\\real-playground\\fake-data\\albums-standard.json"), new TypeReference<List<AlbumJson>>(){});
        List<Album> albums = new ArrayList<>();
        for(AlbumJson albumJson : albumJsons) {
            albums.add(DtoMapper.toAlbum(albumJson));
        }
        return new ResponseEntity<>(albumRepository.saveAll(albums), HttpStatus.OK);
    }

    @GetMapping("/customer")
    @PreAuthorize("hasRole('CUSTOMER')")
    public String customerAccess() {
        return "Customer content";
    }

    @GetMapping("/photographer")
    @PreAuthorize("hasRole('PHOTOGRAPHER')")
    public String photographerAccess() {
        return "Photographer content";
    }

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public String adminAccess() {
        return "Admin content";
    }

}

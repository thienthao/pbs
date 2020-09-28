package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.Album;
import fpt.university.pbswebapi.domain.Photo;
import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.dto.AlbumDto;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.repository.AlbumRepository;
import fpt.university.pbswebapi.repository.PhotographerRepository;
import fpt.university.pbswebapi.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.security.Principal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/albums")
public class AlbumController {
    private AlbumRepository albumRepository;
    private AlbumService albumService;
    private PhotographerRepository photographerRepository;

    @Autowired
    public AlbumController(AlbumRepository albumRepository, AlbumService albumService, PhotographerRepository photographerRepository) {
        this.albumRepository = albumRepository;
        this.albumService = albumService;
        this.photographerRepository = photographerRepository;
    }

    @GetMapping
    public ResponseEntity<List<Album>> findAll() {
        return new ResponseEntity<>(albumService.findAll(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<?> createAlbum(@RequestBody AlbumDto albumDto) {
        // Check principal xem dung thang photographer do hay ko
        // Check album co thumbnail/caption hay ko
        if(albumDto.getPtgId() == null) {
            throw new BadRequestException("Photographer Id cannot be null");
        }

        if(albumDto.getName() == null || albumDto.getName().equals("")) {
            albumDto.setName("Noname");
        }

        // map albumdto <-> album
        Album album = map(albumDto);

        if(album != null) {
            Album returnedAlbum = albumService.createAlbum(album);
            if(returnedAlbum != null)
                return new ResponseEntity<>(returnedAlbum, HttpStatus.CREATED);
            else
                return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        } else {
            throw new BadRequestException("submit fail");
        }
    }

    @PostMapping(value = "/{ptgId}/{albumId}/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> uploadThumbnail(@PathVariable("ptgId") String ptgId,
                                             @PathVariable("albumId") String albumId,
                                             @RequestParam("file") MultipartFile file) {
        //check ptgId
        if(!photographerRepository.findById(Long.parseLong(ptgId)).isPresent())
            throw new BadRequestException("Photographer not exists");
        //check albumId
        if(!albumRepository.findById(Long.parseLong(albumId)).isPresent())
            throw new BadRequestException("Album not exists");

        String fullpath = albumService.uploadAlbumThumbnail(ptgId, albumId, file);
        if(fullpath != null) {
            return new ResponseEntity<>(fullpath, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/{ptgId}/{albumId}/download",
            produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] downloadAlbumThumbnail(@PathVariable("ptgId") String ptgId,
                                           @PathVariable("albumId") String albumId) {
        return albumService.downloadAlbumThumbnail(ptgId, albumId);
    }

    private Album map(AlbumDto albumDto) {
        Optional<Photographer> photographer = photographerRepository.findById(albumDto.getPtgId());
        if(photographer.isPresent()) {
            Album album = new Album();
            album.setName(albumDto.getName());
            album.setPhotographer(photographer.get());
            return album;
        } else {
            return null;
        }
    }
}

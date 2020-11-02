package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.AlbumDto;
import fpt.university.pbswebapi.dto.AlbumDto2;
import fpt.university.pbswebapi.entity.Album;
import fpt.university.pbswebapi.entity.Image;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.AlbumRepository;
import fpt.university.pbswebapi.repository.ImageRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.service.AlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@RestController
@RequestMapping("/api/albums")
public class AlbumController {
    private AlbumRepository albumRepository;
    private AlbumService albumService;
    private UserRepository photographerRepository;
    private ImageRepository imageRepository;

    @Autowired
    public AlbumController(AlbumRepository albumRepository, AlbumService albumService, UserRepository photographerRepository, ImageRepository imageRepository) {
        this.albumRepository = albumRepository;
        this.albumService = albumService;
        this.photographerRepository = photographerRepository;
        this.imageRepository = imageRepository;
    }

    //find all album of 1 particular photographer
    @GetMapping("/photographer/{id}")
    public ResponseEntity<Map<String, Object>> findAllByPhotographerId(
            @PathVariable Long id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<Album> albums = new ArrayList<Album>();
            Pageable paging = PageRequest.of(page, size);

            Page<Album> pageAlbums = albumService.findAllByPhotographerId(id, paging);

            albums = pageAlbums.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("albums", albums);
            response.put("currentPage", pageAlbums.getNumber());
            response.put("totalItems", pageAlbums.getTotalElements());
            response.put("totalPages", pageAlbums.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/photographer/{id}/split")
    public ResponseEntity<Map<String, Object>> findAllSplitByPhotographerId(
            @PathVariable Long id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<Album> albums = new ArrayList<Album>();
            Pageable paging = PageRequest.of(page, size);

            Page<Album> pageAlbums = albumService.findAllByPhotographerId(id, paging);

            albums = pageAlbums.getContent();
            List<AlbumDto2> albumDto2s = new ArrayList<>();
            for(Album album : albums) {
                albumDto2s.add(DtoMapper.toAlbumDto(album));
            }

            Map<String, Object> response = new HashMap<>();
            response.put("albums", albumDto2s);
            response.put("currentPage", pageAlbums.getNumber());
            response.put("totalItems", pageAlbums.getTotalElements());
            response.put("totalPages", pageAlbums.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> findAll(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(name = "categoryId",defaultValue = "1") long categoryId
    ) {
        try {
            List<Album> albums = new ArrayList<Album>();
            Pageable paging = PageRequest.of(page, size);
            Page<Album> pageAlbums;

            if(categoryId != 1) {
                pageAlbums = albumService.findByCategoryIdSortByLike(paging, categoryId);
            } else {
                pageAlbums = albumService.findAllSortByLike(paging);
            }

            albums = pageAlbums.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("albums", albums);
            response.put("currentPage", pageAlbums.getNumber());
            response.put("totalItems", pageAlbums.getTotalElements());
            response.put("totalPages", pageAlbums.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            System.out.println(e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping
    public ResponseEntity<?> createAlbum(@RequestBody AlbumDto albumDto,
                                         @RequestParam("file") MultipartFile file,
                                         @RequestParam("files") MultipartFile[] files) {
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
            if(returnedAlbum != null) {
                albumService.uploadAlbumThumbnail(albumDto.getPtgId().toString(), returnedAlbum.getId().toString(), file);
                albumService.uploadImages(albumDto.getPtgId().toString(), returnedAlbum.getId().toString(), files);
                return new ResponseEntity<>(returnedAlbum, HttpStatus.CREATED);
            }
            else
                return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
        } else {
            throw new BadRequestException("submit fail");
        }
    }

    @PostMapping(value = "/{ptgId}/{albumId}/images",
                consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> uploadImages(@PathVariable("ptgId") String ptgId,
                                          @PathVariable("albumId") String albumId,
                                          @RequestParam("files") MultipartFile[] files) {
        if(!albumRepository.findById(Long.parseLong(albumId)).isPresent())
            throw new BadRequestException("Album not exists");

        List<String> paths = albumService.uploadImages(ptgId, albumId, files);

        if(paths != null) {
            return new ResponseEntity<>(paths, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Fail", HttpStatus.BAD_REQUEST);
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

    @GetMapping(value = "/{ptgId}/{albumId}/images",
            produces = MediaType.IMAGE_JPEG_VALUE)
    public List<byte[]> downloadAlbumImages(@PathVariable("ptgId") String ptgId,
                                            @PathVariable("albumId") String albumId) {
        return albumService.downloadAlbumImages(ptgId, albumId);
    }

    @GetMapping(value = "/{ptgId}/{albumId}/images/{imageId}",
            produces = MediaType.IMAGE_JPEG_VALUE)
    public byte[] downloadAlbumImages(@PathVariable("ptgId") String ptgId,
                                            @PathVariable("albumId") String albumId,
                                            @PathVariable("imageId") String imageId) {
        return albumService.downloadImage(ptgId, albumId,imageId);
    }

    private Album map(AlbumDto albumDto) {
        Optional<User> photographer = photographerRepository.findById(albumDto.getPtgId());
        if(photographer.isPresent()) {
            Album album = new Album();
            album.setName(albumDto.getName());
            album.setPhotographer(photographer.get());
            album.setDescription(albumDto.getDescription());
            return album;
        } else {
            return null;
        }
    }

    @PostMapping(value = "/{ptgId}/{albumId}/fakeimages",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public void fakeImages(@PathVariable("ptgId") String ptgId,
                                          @PathVariable("albumId") String albumId,
                                          @RequestParam("files") MultipartFile[] files) {
        Album album = albumRepository.getOne(Long.parseLong(albumId));
        int i = 0;
        for (Image image : album.getImages()) {
            albumService.fakeAlbumImage(ptgId, albumId, files[i], image);
            i++;
        }
    }

    @PostMapping("/fakethumbnail")
    public void fakeThumbnail(@RequestParam("file") MultipartFile[] file) {
        List<Album> albums= albumRepository.findAll();
        int i = 0;
        for(Album album : albums) {
            albumService.uploadAlbumThumbnail(album.getPhotographer().getId().toString(), album.getId().toString(), file[i++]);
        }
    }
}

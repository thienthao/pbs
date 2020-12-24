package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.entity.Album;
import fpt.university.pbswebapi.entity.Image;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.repository.AlbumRepository;
import fpt.university.pbswebapi.repository.CustomRepository;
import fpt.university.pbswebapi.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

import static org.apache.http.entity.ContentType.*;

@Service
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final FileStore fileStore;
    private final ImageRepository imageRepository;

    @Autowired
    private CustomRepository customRepository;

    @Autowired
    public AlbumService(AlbumRepository albumRepository, FileStore fileStore, ImageRepository imageRepository) {
        this.albumRepository = albumRepository;
        this.fileStore = fileStore;
        this.imageRepository = imageRepository;
    }

    public List<Album> findAllSortByLike() {
        List<Album> results = customRepository.getAlbumSortByLikes();
        for(Album album : results) {
            album.setImages(customRepository.getImageOfAlbum(album.getId()));
        }
        return results;
    }

    public Album createAlbum(Album album) {
        album.setCreatedAt(new Date());
        return albumRepository.save(album);
    }

    public String uploadAlbumThumbnail(String ptgId, String albumId, MultipartFile file) {
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
        String path = String.format("%s/%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), ptgId, albumId);
        String filename = String.format("%s-%s", albumId, "thumbnail");

        // Get album to set thumbnail link
        Optional<Album> albumOptional = albumRepository.findById(Long.parseLong(albumId));
        if(albumOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                Album album = albumOptional.get();
                album.setThumbnail("http://194.59.165.195:8080/pbs-webapi/api/albums/" + ptgId+ "/" + albumId +"/download");
                albumRepository.save(album);
                return "http://194.59.165.195:8080/pbs-webapi/api/albums/" + ptgId+ "/" + albumId +"/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public byte[] downloadAlbumThumbnail(String ptgId, String albumId) {
        String path = String.format("%s/%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                ptgId,
                albumId);
        return fileStore.download(path, albumId + "-thumbnail");
    }

    public List<byte[]> downloadAlbumImages(String ptgId, String albumId) {
        List<byte[]> images = new ArrayList<>();
        Optional<Album> album = albumRepository.findById(Long.parseLong(albumId));
        for(Image image : album.get().getImages()) {
            String path = String.format("%s/%s/%s",
                    BucketName.PROFILE_IMAGE.getBucketName(),
                    ptgId,
                    albumId);
            images.add(fileStore.download(path, image.getId() + "-image"));
        }
        return images;
    }

    public List<Album> findAllByPhotographerId(Long photographerId) {
        List<Album> results = customRepository.getAlbumSortByLikes(photographerId);
        for(Album album : results) {
            album.setImages(customRepository.getImageOfAlbum(album.getId()));
        }
        return results;
    }

    public List<String> uploadImages(String ptgId, String albumId, MultipartFile[] files) {
        List<String> paths = new ArrayList<>();

        if(files == null) {
            throw new IllegalStateException("Cannot upload empty files");
        }

        for (MultipartFile file : files) {
            if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
                throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
            }
        }

        Optional<Album> optAlbum = albumRepository.findById(Long.parseLong(albumId));
        Album album = optAlbum.get();
        List<Image> images = new ArrayList<>();

        for (MultipartFile file : files) {
            Map<String, String> metadata = new HashMap<>();
            metadata.put("Content-Type", file.getContentType());
            metadata.put("Content-Length", String.valueOf(file.getSize()));

            Image image = new Image();
            image = imageRepository.save(image);
            // format file name and path
            String path = String.format("%s/%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), ptgId, albumId);
            String filename = String.format("%s-%s", image.getId(), "image");
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                image.setImageLink("http://194.59.165.195:8080/pbs-webapi/api/albums/" + ptgId + "/" + albumId + "/images/" + image.getId());
                image.setAlbums(new ArrayList<>(List.of(album)));
                imageRepository.save(image);
                paths.add("http://194.59.165.195:8080/pbs-webapi/api/albums/" + ptgId + "/" + albumId + "/images/" + image.getId());
                images.add(image);
            } catch (Exception e) {
                imageRepository.delete(image);
                throw new IllegalStateException(e);
            }
        }
        album.setImages(images);
        albumRepository.save(album);
        return paths;
    }

    public byte[] downloadImage(String ptgId, String albumId, String imageId) {
        String path = String.format("%s/%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                ptgId,
                albumId);
        return fileStore.download(path, imageId + "-image");
    }

    public String uploadAlbumThumbnailTest(String ptgId, String albumId, MultipartFile file) {
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
        String path = String.format("%s/%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), ptgId, albumId);
        String filename = String.format("http://194.59.165.195:8080/pbs-webapi/api/albums/%s/%s/download", ptgId, albumId);

        // Get album to set thumbnail link
        Optional<Album> albumOptional = albumRepository.findById(Long.parseLong(albumId));
        if(albumOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
//                String fullpath = String.format("%s/%s", path, filename);
                Album album = albumOptional.get();
                album.setThumbnail(filename);
                albumRepository.save(album);
//                return fullpath;
                return filename;
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public void fakeAlbumImage(String ptgId, String albumId, MultipartFile file, Image image) {
        List<String> paths = new ArrayList<>();

        if(file == null) {
            throw new IllegalStateException("Cannot upload empty files");
        }

        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), ptgId, albumId);
        String filename = String.format("%s-%s", image.getId(), "image");
        try {
            fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
            String fullpath = String.format("%s/%s", path, filename);
            image.setImageLink("http://194.59.165.195:8080/pbs-webapi/api/albums/" + ptgId + "/" + albumId + "/images/" + image.getId());
            imageRepository.save(image);
        } catch (Exception e) {
            imageRepository.delete(image);
            throw new IllegalStateException(e);
        }
    }

    public List<Album> findByCategoryIdSortByLike(long categoryId) {
        List<Album> results = customRepository.getAlbumByCategorySortByLikes(categoryId);
        for(Album album : results) {
            album.setImages(customRepository.getImageOfAlbum(album.getId()));
        }
        return results;
    }

    public int likeAlbum(Long albumId, Long userId) {
        return customRepository.likeAlbum(albumId, userId);
    }

    public int unlikeAlbum(Long albumId, Long userId) {
        return customRepository.unlikeAlbum(albumId, userId);
    }

    public int isLike(Long albumId, Long userId) {
        return customRepository.isLike(albumId, userId);
    }
}

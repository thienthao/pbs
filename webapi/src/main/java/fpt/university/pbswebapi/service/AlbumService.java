package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.domain.Album;
import fpt.university.pbswebapi.domain.UserProfile;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.repository.AlbumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

import static org.apache.http.entity.ContentType.*;

@Service
public class AlbumService {
    private final AlbumRepository albumRepository;
    private final FileStore fileStore;

    @Autowired
    public AlbumService(AlbumRepository albumRepository, FileStore fileStore) {
        this.albumRepository = albumRepository;
        this.fileStore = fileStore;
    }

    public List<Album> findAll() {
        return albumRepository.findAll();
    }

    public Album createAlbum(Album album) {
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
                album.setThumbnail(fullpath);
                albumRepository.save(album);
                return fullpath;
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
}

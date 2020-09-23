package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.domain.Album;
import fpt.university.pbswebapi.repository.AlbumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AlbumService {
    private AlbumRepository albumRepository;

    @Autowired
    public AlbumService(AlbumRepository albumRepository) {
        this.albumRepository = albumRepository;
    }

    public List<Album> findAll() {
        return albumRepository.findAll();
    }
}

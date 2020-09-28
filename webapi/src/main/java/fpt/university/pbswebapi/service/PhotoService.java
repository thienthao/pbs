package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.domain.Photo;
import fpt.university.pbswebapi.repository.PhotoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PhotoService {

    private PhotoRepository photoRepository;

    @Autowired
    public PhotoService(PhotoRepository photoRepository) {
        this.photoRepository = photoRepository;
    }

    public List<Photo> findAll() {
        return photoRepository.findAll();
    }
}

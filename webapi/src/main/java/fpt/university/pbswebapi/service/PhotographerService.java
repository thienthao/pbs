package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.repository.PhotographerRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PhotographerService {
    private PhotographerRepository phtrRepo;

    public PhotographerService(PhotographerRepository phtrRepo) {
        this.phtrRepo = phtrRepo;
    }

    public List<Photographer> findAll() {
        return phtrRepo.findAll();
    }

    public List<Photographer> findAllByNameContaining(String name) {
        return phtrRepo.findAllByNameContaining(name);
    }
}

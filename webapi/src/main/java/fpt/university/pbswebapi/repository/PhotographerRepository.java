package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.Photographer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PhotographerRepository extends JpaRepository<Photographer, Long> {
    List<Photographer> findAllByNameContaining(String name);
}

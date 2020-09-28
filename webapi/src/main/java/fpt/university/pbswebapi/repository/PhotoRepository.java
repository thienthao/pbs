package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.Photo;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PhotoRepository extends JpaRepository<Photo, Long> {
}

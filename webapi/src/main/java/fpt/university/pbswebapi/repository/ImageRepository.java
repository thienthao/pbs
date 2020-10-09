package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Image;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ImageRepository extends JpaRepository<Image, Long> {
}

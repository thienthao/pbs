package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.Album;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlbumRepository extends JpaRepository<Album, Long> {
}

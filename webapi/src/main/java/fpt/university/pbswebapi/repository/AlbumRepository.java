package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.Album;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface AlbumRepository extends JpaRepository<Album, Long> {
}

package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Album;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;


public interface AlbumRepository extends JpaRepository<Album, Long> {

    Page<Album> findAllByPhotographerId(Long id, Pageable paging);
}

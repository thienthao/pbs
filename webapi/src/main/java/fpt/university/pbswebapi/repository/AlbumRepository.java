package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Album;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;


public interface AlbumRepository extends JpaRepository<Album, Long> {

    Page<Album> findAllByPhotographerId(Long id, Pageable paging);

    @Query("from Album album order by album.likes desc ")
    Page<Album> findAllSortByLike(Pageable paging);

    @Query("from Album album where album.category.id =:categoryId order by album.likes desc ")
    Page<Album> findByCategoryIdSortByLike(Pageable paging, int categoryId);
}

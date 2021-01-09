package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Album;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;


public interface AlbumRepository extends JpaRepository<Album, Long> {

    Page<Album> findAllByPhotographerIdAndIsDeletedFalse(Long id, Pageable paging);

    @Query("from Album album where album.isDeleted=false order by album.likes desc ")
    Page<Album> findAllSortByLike(Pageable paging);

    @Query("from Album album where album.category.id =:categoryId and album.isDeleted=false order by album.likes desc ")
    Page<Album> findByCategoryIdSortByLike(Pageable paging, long categoryId);

    @Transactional
    @Modifying
    @Query("update Album album set album.isDeleted=true where album.id=:albumId")
    void delete(long albumId);
}

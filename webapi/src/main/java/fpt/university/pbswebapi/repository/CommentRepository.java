package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.BookingComment;
import fpt.university.pbswebapi.entity.Report;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface CommentRepository extends JpaRepository<BookingComment, Long> {

    List<BookingComment> findAllByUserId(long userId);

    List<BookingComment> findAllByBookingId(long bookingId);

    @Query("select c " +
            "from BookingComment c " +
            "order by c.commentedAt desc," +
            "c.rating asc")
    Page<BookingComment> findCommentOrderByCommentedAt(Pageable pageable);

    @Query("select c " +
            "from BookingComment c " +
            "inner join c.booking b " +
            "where b.photographer.id=:photographerId " +
            "and b.bookingStatus='DONE' " +
            "order by c.commentedAt desc")
    List<BookingComment> findCommentOfPhotographer(Long photographerId, Pageable pageable);

    @Query("SELECT AVG(c.rating) " +
            "FROM BookingComment c " +
            "inner join Booking b " +
            "inner join User u " +
            "where u.id = :photographerId")
    Double getRatingCount(Long photographerId);

    @Query("select c from BookingComment c " +
            "where c.rating >= 0 and c.rating < 1 " +
            "order by c.commentedAt desc, c.commentedAt")
    Page<BookingComment> findAllOne(Pageable pageable);

    @Query("select c from BookingComment c " +
            "where c.rating >= 1 and c.rating < 2 " +
            "order by c.commentedAt desc, c.commentedAt")
    Page<BookingComment> findAllTwo(Pageable pageable);

    @Query("select c from BookingComment c " +
            "where c.rating >= 2 and c.rating < 3 " +
            "order by c.commentedAt desc, c.commentedAt")
    Page<BookingComment> findAllThree(Pageable pageable);

    @Query("select c from BookingComment c " +
            "where c.rating >= 3 and c.rating < 4 " +
            "order by c.commentedAt desc, c.commentedAt")
    Page<BookingComment> findAllFour(Pageable pageable);

    @Query("select c from BookingComment c " +
            "where c.rating >= 4 and c.rating < 5 " +
            "order by c.commentedAt desc, c.commentedAt")
    Page<BookingComment> findAllFive(Pageable pageable);

    @Query("from BookingComment c where c.rating >= 0 and c.rating < 1 and c.commentedAt>=:start and c.commentedAt<=:end order by c.commentedAt desc")
    Page<BookingComment> findAllOneByDate(Date start, Date end, Pageable pageable);

    @Query("from BookingComment c where c.rating >= 1 and c.rating < 2 and c.commentedAt>=:start and c.commentedAt<=:end order by c.commentedAt desc")
    Page<BookingComment> findAllTwoByDate(Date start, Date end, Pageable pageable);

    @Query("from BookingComment c where c.rating >= 2 and c.rating < 3 and c.commentedAt>=:start and c.commentedAt<=:end order by c.commentedAt desc")
    Page<BookingComment> findAllThreeByDate(Date start, Date end, Pageable pageable);

    @Query("from BookingComment c where c.rating >= 3 and c.rating < 4 and c.commentedAt>=:start and c.commentedAt<=:end order by c.commentedAt desc")
    Page<BookingComment> findAllFourByDate(Date start, Date end, Pageable pageable);

    @Query("from BookingComment c where c.rating >= 4 and c.rating < 5 and c.commentedAt>=:start and c.commentedAt<=:end order by c.commentedAt desc")
    Page<BookingComment> findAllFiveByDate(Date start, Date end, Pageable pageable);

    @Query("from BookingComment c where c.commentedAt>=:start and c.commentedAt<=:end order by c.commentedAt desc")
    Page<BookingComment> findByDateAll(Date start, Date end, Pageable pageable);
}

package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.BookingComment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CommentRepository extends JpaRepository<BookingComment, Long> {

    List<BookingComment> findAllByUserId(long userId);

    List<BookingComment> findAllByBookingId(long bookingId);

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
}

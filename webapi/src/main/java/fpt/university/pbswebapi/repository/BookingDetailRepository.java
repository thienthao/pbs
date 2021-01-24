package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.BookingDetail;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookingDetailRepository extends JpaRepository<BookingDetail, Long> {

    List<BookingDetail> findAllByBookingId(Long bookingId);
}

package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {

    @Query("FROM Booking b where b.customer.id = :userId and b.bookingStatus = :bookingStatus or b.photographer.id= :userId and b.bookingStatus = :bookingStatus")
    Page<Booking> byStatus(EBookingStatus bookingStatus, Pageable paging, Long userId);

    @Query("FROM Booking b where b.startDate > current_date")
    Page<Booking> sortByStartDate(Pageable paging);


//    Page<Booking> findAllByBookingStatusEqualsAndCustomerIdOrBookingStatusEqualsAndPhotographerId(EBookingStatus bookingStatus, Pageable paging, Long customerId, Long photographerId);

    private String statusToString(EBookingStatus status) {
        return status.toString();
    }

    @Query("FROM Booking b where b.customer.id = :userId or b.photographer.id = :userId")
    Page<Booking> all(Pageable paging, Long userId);

    @Query("FROM Booking b where b.photographer.id = :photographerId")
    List<Booking> findBookingsOfPhotographer(Long photographerId);

    @Query("FROM Booking b where b.customer.id = :customerId")
    Page<Booking> getAllByCustomer(Pageable paging, Long customerId);

}

package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {

    @Query("FROM Booking b where b.customer.id = :userId and b.bookingStatus = :bookingStatus or b.photographer.id= :userId and b.bookingStatus = :bookingStatus order by b.startDate desc")
    Page<Booking> byStatus(EBookingStatus bookingStatus, Pageable paging, Long userId);

    @Query("FROM Booking b where b.customer.id = :userId and b.bookingStatus = :bookingStatus or b.customer.id= :customerId and b.bookingStatus = :bookingStatus order by b.startDate desc")
    Page<Booking> byStatusForCustomer(EBookingStatus bookingStatus, Pageable paging, Long customerId);

    @Query("FROM Booking b where b.bookingStatus = :bookingStatus")
    Page<Booking> byStatusWithoutUserId(EBookingStatus bookingStatus, Pageable paging);

    @Query("FROM Booking b where b.startDate > current_date")
    Page<Booking> sortByStartDate(Pageable paging);


//    Page<Booking> findAllByBookingStatusEqualsAndCustomerIdOrBookingStatusEqualsAndPhotographerId(EBookingStatus bookingStatus, Pageable paging, Long customerId, Long photographerId);

    private String statusToString(EBookingStatus status) {
        return status.toString();
    }

    @Query("FROM Booking b where b.customer.id = :userId or b.photographer.id = :userId")
    Page<Booking> all(Pageable paging, Long userId);

    @Query("FROM Booking b where b.photographer.id = :photographerId and b.bookingStatus='DONE'")
    List<Booking> findBookingsOfPhotographer(Long photographerId);

    @Query("FROM Booking b where b.photographer.id = :photographerId and b.bookingStatus='ONGOING' " +
            "or b.photographer.id = :photographerId and b.bookingStatus='EDITING'" +
            "order by b.startDate asc")
    List<Booking> findBookingsByPhotographerId(Long photographerId);

    @Query("FROM Booking b where b.customer.id = :customerId order by b.startDate desc")
    Page<Booking> getAllByCustomer(Pageable paging, Long customerId);

    @Query("FROM Booking b where b.customer.id = :customerId order by b.id desc")
    Page<Booking> getAllByCustomerSortById(Pageable paging, Long customerId);

    @Query("FROM Booking b where b.photographer.id = :photographerId order by b.id desc")
    Page<Booking> getPhotographerPendingBookingSortById(Pageable paging, Long photographerId);

    @Query("FROM Booking b where b.photographer.id = :photographerId")
    Page<Booking> findAllOfPhotographer(Pageable paging, Long photographerId);

    @Query("FROM Booking b where b.photographer.id =:photographerId and b.bookingStatus =:valueOf order by b.startDate desc, b.id desc")
    Page<Booking> findAllOfPhotographerByStatus(EBookingStatus valueOf, Pageable paging, Long photographerId);

    @Query("FROM Booking b where b.photographer.id =:photographerId and b.startDate between :date1 and :date2 and b.bookingStatus='ONGOING'" +
            "or b.photographer.id =:photographerId and b.startDate between :date1 and :date2 and b.bookingStatus='EDITING'")
    Page<Booking> findPhotographerBookingByDate(Pageable paging, Date date1, Date date2, Long photographerId);

    @Query("FROM Booking b where b.photographer.id =:photographerId and b.startDate between :date1 and :date2 and b.bookingStatus='ONGOING'" +
            "or b.photographer.id =:photographerId and b.startDate between :date1 and :date2 and b.bookingStatus='EDITING'")
    List<Booking> findPhotographerBookingByDate(Date date1, Date date2, Long photographerId);

    @Query("From Booking b " +
            "inner join b.timeLocationDetails ltd " +
            "where b.photographer.id =:ptgId and b.bookingStatus='ONGOING' " +
            "or b.photographer.id =:ptgId and b.bookingStatus='EDITING' " +
            "order by ltd.start asc")
    List<Booking> findOnGoingNEditingBookingsBetween(long ptgId);

    @Query("From Booking b " +
            "inner join b.timeLocationDetails ltd " +
            "where b.photographer.id =:ptgId and b.bookingStatus='ONGOING' " +
            "order by ltd.start asc")
    List<Booking> findOnGoingBookingsBetween(long ptgId);

    @Query("select count(b) " +
            "from Booking b " +
            "inner join b.timeLocationDetails tld " +
            "where tld.start>=:from and tld.start<=:to and b.bookingStatus='ONGOING' " +
            "or b.editDeadline>=:from and b.editDeadline<=:to and b.bookingStatus='EDITING'")
    Long countOngoingNEditOnDate(Date from, Date to);

    @Query("select count(b) " +
            "from Booking b " +
            "where b.editDeadline>=:from and b.editDeadline<=:to")
    Long countEditBookingOnDate(Date from, Date to);

    @Query("FROM Booking b " +
            "inner join b.timeLocationDetails tld " +
            "where b.photographer.id =:photographerId and tld.start>=:from and tld.start<=:to " +
            "and b.bookingStatus='ONGOING'")
    List<Booking> findOngoingBookingOnDate(Date from, Date to, Long photographerId);

    @Query("FROM Booking b " +
            "where b.photographer.id =:photographerId and b.editDeadline>=:from and b.editDeadline<=:to " +
            "and b.bookingStatus='EDITING'")
    List<Booking> findEditingBookingOnDate(Date from, Date to, Long photographerId);

    @Query("select count(b) from Booking b inner join b.servicePackage pc where pc.id=:packageId and b.bookingStatus<>'DONE'")
    long countPackageBeingUsed(long packageId);


}

package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class BookingService {

    private BookingRepository bookingRepository;

    @Autowired
    public BookingService(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    public Booking book(Booking booking) {
        return bookingRepository.save(booking);
    }

    public Page<Booking> findByStatus(EBookingStatus status, Pageable paging, Long userId) {
        return bookingRepository.byStatus(status, paging, userId);
    }

    public Page<Booking> findAll(Pageable paging, Long cusId) {
        return bookingRepository.all(paging, cusId);
    }

    public Booking save(Booking booking) {
        return bookingRepository.save(booking);
    }

    public Page<Booking> findAllOfPhotographer(Pageable paging, Long photographerId) {
        return bookingRepository.findAllOfPhotographer(paging, photographerId);
    }

    public Page<Booking> findAllOfPhotographerByStatus(EBookingStatus valueOf, Pageable paging, Long photographerId) {
        return bookingRepository.findAllOfPhotographerByStatus(valueOf, paging, photographerId);
    }
}

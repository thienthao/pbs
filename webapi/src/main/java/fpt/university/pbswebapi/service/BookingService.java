package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
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
}

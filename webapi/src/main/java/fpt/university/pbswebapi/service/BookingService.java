package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpServerErrorException;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;

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

    public Page<Booking> findPhotographerBookingByDate(String date, Pageable paging, Long photographerId) {
        try {
            if(date.equalsIgnoreCase("")) {
                date = LocalDate.now().toString();
            }
            String textdate1 = date + " 00:00";
            String textdate2 = date + " 23:59";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime localDate1 = LocalDateTime.parse(textdate1, formatter);
            LocalDateTime localDate2 = LocalDateTime.parse(textdate2, formatter);
            Date date1 = convertToDateViaInstant(localDate1);
            Date date2 = convertToDateViaInstant(localDate2);
            return bookingRepository.findPhotographerBookingByDate(paging, date1, date2, photographerId);
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public Date convertToDateViaInstant(LocalDate dateToConvert) {
        return java.util.Date.from(dateToConvert.atStartOfDay()
                .atZone(ZoneId.systemDefault())
                .toInstant());
    }

    Date convertToDateViaInstant(LocalDateTime dateToConvert) {
        return java.util.Date
                .from(dateToConvert.atZone(ZoneId.systemDefault())
                        .toInstant());
    }
}

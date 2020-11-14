package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.CommentDto;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.BookingComment;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class BookingService {

    private BookingRepository bookingRepository;
    private CommentRepository commentRepository;

    @Autowired
    public BookingService(BookingRepository bookingRepository, CommentRepository commentRepository) {
        this.bookingRepository = bookingRepository;
        this.commentRepository = commentRepository;
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
            Date date1 = DateHelper.convertToDateViaInstant(localDate1);
            Date date2 = DateHelper.convertToDateViaInstant(localDate2);
            return bookingRepository.findPhotographerBookingByDate(paging, date1, date2, photographerId);
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public Map<Date, List<Booking>> getPhotographerBookingByDateRange(Long ptgId, String fromString, String toString) {
        Map<Date, List<Booking>> result = new HashMap<>();
        try {
            //get List from date to date
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            LocalDate localFrom = LocalDate.parse(fromString, formatter);
            LocalDate localTo = LocalDate.parse(toString, formatter);
            List<LocalDate> range = DateHelper.getDatesBetween(localFrom, localTo);
            for(LocalDate localDate : range) {
                String tmpStart = localDate.toString() + " 00:00";
                String tmpEnd = localDate.toString() + " 23:59";
                DateTimeFormatter localDateTimeFormmater = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                LocalDateTime localStart = LocalDateTime.parse(tmpStart, localDateTimeFormmater);
                LocalDateTime localEnd = LocalDateTime.parse(tmpEnd, localDateTimeFormmater);
                Date from = DateHelper.convertToDateViaInstant(localStart);
                Date to = DateHelper.convertToDateViaInstant(localEnd);
                result.put(from, bookingRepository.findPhotographerBookingByDate(from, to, ptgId));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return result;
    }

    public List<CommentDto> findCommentsOfBooking(long bookingId) {
        List<BookingComment> comments = commentRepository.findAllByBookingId(bookingId);
        List<CommentDto> result = new ArrayList<>();
        for(BookingComment comment : comments) {
            result.add(DtoMapper.toCommentDto(comment));
        }
        return result;
    }

    public List<BookingComment> getCommentJson(long bookingId) {
        return commentRepository.findAllByBookingId(bookingId);
    }

    public BookingComment comment(BookingComment comment) {
        return commentRepository.save(comment);
    }

    public List<CommentDto> findCommentsOfPhotographer(Long photographerId, Pageable pageable) {
        List<BookingComment> comments = commentRepository.findCommentOfPhotographer(photographerId, pageable);
        List<CommentDto> result = new ArrayList<>();
        for(BookingComment comment : comments) {
            result.add(DtoMapper.toCommentDto(comment));
        }
        return result;
    }
}

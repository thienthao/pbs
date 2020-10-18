package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.CommentDto;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.security.services.UserDetailsImpl;
import fpt.university.pbswebapi.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    private BookingService bookingService;
    private BookingRepository bookingRepository;

    @Autowired
    public BookingController(BookingService bookingService, BookingRepository bookingRepository) {
        this.bookingService = bookingService;
        this.bookingRepository = bookingRepository;
    }

    @GetMapping("/test")
    public ResponseEntity<Map<String, Object>> sortByDate(@RequestParam(defaultValue = "0") int page,
                                                          @RequestParam(defaultValue = "5") int size) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            pageBookings = bookingRepository.sortByStartDate(paging);

            bookings = pageBookings.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("bookings", bookings);
            response.put("currentPage", pageBookings.getNumber());
            response.put("totalItems", pageBookings.getTotalElements());
            response.put("totalPages", pageBookings.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/customer/{customerId}")
    public ResponseEntity<Map<String, Object>> getAllByCustomer(@RequestParam(defaultValue = "0") int page,
                                                                @RequestParam(defaultValue = "5") int size,
                                                                @PathVariable("customerId") Long customerId) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            pageBookings = bookingRepository.getAllByCustomer(paging, customerId);

            bookings = pageBookings.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("bookings", bookings);
            response.put("currentPage", pageBookings.getNumber());
            response.put("totalItems", pageBookings.getTotalElements());
            response.put("totalPages", pageBookings.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Booking> getBookingById(@PathVariable Long id) {
        return new ResponseEntity<>(bookingRepository.findById(id).get(), HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> findByStatus(
            @RequestParam(required = false) String status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size
    ) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            if(status == null) {
                pageBookings = bookingService.findAll(paging, getCurrentUserId());
            }
            else
                pageBookings = bookingService.findByStatus(EBookingStatus.valueOf(status.toUpperCase()), paging, getCurrentUserId());

            bookings = pageBookings.getContent();
            Map<String, Object> response = new HashMap<>();
            response.put("bookings", bookings);
            response.put("currentPage", pageBookings.getNumber());
            response.put("totalItems", pageBookings.getTotalElements());
            response.put("totalPages", pageBookings.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            System.out.println(e);
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/photographer/{id}/comments")
    public ResponseEntity<List<CommentDto>> getCommentsOfPhotographer(@PathVariable("id") Long photographerId) {
        List<Booking> bookings = bookingRepository.findBookingsOfPhotographer(photographerId);
        List<CommentDto> commentDtos = new ArrayList<>();
        for(Booking booking : bookings) {
            commentDtos.add(new CommentDto(booking.getComment(), booking.getRating(), booking.getCustomer().getUsername(), booking.getCustomer().getFullname(), booking.getCommentDate(), booking.getLocation(), booking.getCustomer().getAvatar()));
        }
        return new ResponseEntity<>(commentDtos, HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<Booking> book(@RequestBody Booking booking) {
        // require status
        // require .... validate
        booking.setBookingStatus(EBookingStatus.PENDING);
        return new ResponseEntity<Booking>(bookingService.book(booking), HttpStatus.OK);
    }

    @PutMapping("/cancel")
    public ResponseEntity<Booking> cancel(@RequestBody Booking booking) {
        // if status not hop ly
        // check co dung nguoi ko
        Booking savedBooking = bookingRepository.getOne(booking.getId());
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        booking.setBookingStatus(EBookingStatus.CANCELED);
        return new ResponseEntity<Booking>(bookingService.save(booking), HttpStatus.OK);
    }

    @PutMapping("/reject")
    public ResponseEntity<Booking> reject(@RequestBody Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.getOne(booking.getId());
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 1");
//        }

        booking.setBookingStatus(EBookingStatus.REJECTED);
        return new ResponseEntity<Booking>(bookingService.save(booking), HttpStatus.OK);
    }

    @PutMapping("/accept")
    public ResponseEntity<Booking> accept(@RequestBody Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 1");
//        }

        booking.setBookingStatus(EBookingStatus.ONGOING);
        return new ResponseEntity<Booking>(bookingService.save(booking), HttpStatus.OK);
    }

    @PutMapping("/done")
    public ResponseEntity<Booking> done(@RequestBody Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.getOne(booking.getId());
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        booking.setBookingStatus(EBookingStatus.DONE);
        return new ResponseEntity<Booking>(bookingService.save(booking), HttpStatus.OK);
    }

    @PutMapping("/editing")
    public ResponseEntity<Booking> editing(@RequestBody Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.getOne(booking.getId());
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        booking.setBookingStatus(EBookingStatus.EDITING);
        return new ResponseEntity<Booking>(bookingService.save(booking), HttpStatus.OK);
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl user = (UserDetailsImpl) authentication.getPrincipal();
        return user.getId();
    }

    private Boolean isBookingOfUser(Long bookingUserId) {
        if(bookingUserId != getCurrentUserId()) {
            return false;
        }
        return true;
    }
}
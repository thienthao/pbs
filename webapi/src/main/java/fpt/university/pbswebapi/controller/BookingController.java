package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.CommentDto;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.BookingComment;
import fpt.university.pbswebapi.entity.EBookingStatus;
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

import java.util.*;

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

    @GetMapping("/customer/{customerId}/id")
    public ResponseEntity<Map<String, Object>> getAllByCustomerSortById(@RequestParam(defaultValue = "0") int page,
                                                                @RequestParam(defaultValue = "5") int size,
                                                                @PathVariable("customerId") Long customerId) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            pageBookings = bookingRepository.getAllByCustomerSortById(paging, customerId);

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

    @GetMapping("/photographer/{photographerId}/id")
    public ResponseEntity<Map<String, Object>> getPhotographerPendingBookingSortById(@RequestParam(defaultValue = "0") int page,
                                                                        @RequestParam(defaultValue = "5") int size,
                                                                        @PathVariable("photographerId") Long photographerId) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            pageBookings = bookingRepository.getPhotographerPendingBookingSortById(paging, photographerId);

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

    @GetMapping("/photographer/{photographerId}/date")
    public ResponseEntity<Map<String, Object>> getPhotographerBookingByDate(@RequestParam(defaultValue = "0") int page,
                                                                                   @RequestParam(defaultValue = "5") int size,
                                                                                   @RequestParam(defaultValue = "") String date,
                                                                                   @PathVariable("photographerId") Long photographerId) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            pageBookings = bookingService.findPhotographerBookingByDate(date, paging, photographerId);

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

    @GetMapping("/photographer/{ptgId}/daterange")
    public ResponseEntity<Map<Date, List<Booking>>> getPhotographerBookingByDateRange(@RequestParam("from") String from,
                                                                          @RequestParam("to") String to,
                                                                          @PathVariable("ptgId") Long ptgId) {
        return new ResponseEntity<>(bookingService.getPhotographerBookingByDateRange(ptgId, from, to), HttpStatus.OK);
    }

    @GetMapping("/photographer/{photographerId}/status")
    public ResponseEntity<Map<String, Object>> getPhotographerByStatusSortById(@RequestParam(required = false) String status,
                                                                               @RequestParam(defaultValue = "0") int page,
                                                                               @RequestParam(defaultValue = "5") int size,
                                                                               @PathVariable("photographerId") Long photographerId) {
        try {
            List<Booking> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            if(status == null) {
                pageBookings = bookingService.findAllOfPhotographer(paging, photographerId);
            }
            else
                pageBookings = bookingService.findAllOfPhotographerByStatus(EBookingStatus.valueOf(status.toUpperCase()), paging, photographerId);

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

    @GetMapping("/customer/{customerId}/status")
    public ResponseEntity<Map<String, Object>> findByStatus(
            @PathVariable("customerId") Long customerId,
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
                pageBookings = bookingService.findByStatus(EBookingStatus.valueOf(status.toUpperCase()), paging, customerId);

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
    public ResponseEntity<List<CommentDto>> getCommentsOfPhotographer(
            @PathVariable("id") Long photographerId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "5") int size) {
        Pageable pageable = PageRequest.of(page, size);
        return new ResponseEntity<List<CommentDto>>(bookingService.findCommentsOfPhotographer(photographerId, pageable) ,HttpStatus.OK);
    }

    @GetMapping("/testtimewarning")
    public ResponseEntity<?> testTimeWarning() {
        Booking booking = bookingRepository.findById(Long.parseLong("257")).get();
        return new ResponseEntity<>(bookingService.warnBookingTime(booking), HttpStatus.OK);
    }

    @GetMapping("/testdistancewarning")
    public ResponseEntity<?> testDistanceWarning() {
        Booking booking = bookingRepository.findById(Long.parseLong("257")).get();
        return new ResponseEntity<>(bookingService.warnDistance(booking), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<Booking> book(@RequestBody Booking booking) {
        // require status
        // require .... validate
        booking.setBookingStatus(EBookingStatus.PENDING);
        return new ResponseEntity<Booking>(bookingService.book(booking), HttpStatus.OK);
    }

    @PutMapping("/cancel/customer")
    public ResponseEntity<Booking> cancelForCustomer(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.cancelForCustomer(booking), HttpStatus.OK);
    }

    @PutMapping("/cancel/photographer")
    public ResponseEntity<Booking> cancelForPhotographer(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.cancelForPhotographer(booking), HttpStatus.OK);
    }

    @PutMapping("/reject")
    public ResponseEntity<Booking> reject(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.reject(booking), HttpStatus.OK);
    }

    @PutMapping("/accept")
    public ResponseEntity<Booking> accept(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.accept(booking), HttpStatus.OK);
    }

    @PutMapping("/done")
    public ResponseEntity<Booking> done(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.done(booking), HttpStatus.OK);
    }

    @PutMapping("/editing")
    public ResponseEntity<Booking> editing(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.editing(booking), HttpStatus.OK);
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetailsImpl user = (UserDetailsImpl) authentication.getPrincipal();
        return user.getId();
    }

    @GetMapping("/{bookingId}/comments")
    public ResponseEntity<?> findCommentsOfBooking(@PathVariable("bookingId") long bookingId) {
        return new ResponseEntity<>(bookingService.findCommentsOfBooking(bookingId), HttpStatus.OK);
    }

    @GetMapping("/{bookingId}/comments/json")
    public ResponseEntity<?> findCommentsOfBookingTest(@PathVariable("bookingId") long bookingId) {
        return new ResponseEntity<>(bookingService.getCommentJson(bookingId), HttpStatus.OK);
    }

    @PostMapping("/{bookingId}/comments")
    public ResponseEntity<?> findCommentsOfBooking(@PathVariable("bookingId") long bookingId, @RequestBody BookingComment comment) {
        return new ResponseEntity<>(bookingService.comment(comment), HttpStatus.OK);
    }

    private Boolean isBookingOfUser(Long bookingUserId) {
        if(bookingUserId != getCurrentUserId()) {
            return false;
        }
        return true;
    }

    public static <T> List<List<T>> getPages(Collection<T> c, Integer pageSize) {
        if (c == null)
            return Collections.emptyList();
        List<T> list = new ArrayList<T>(c);
        if (pageSize == null || pageSize <= 0 || pageSize > list.size())
            pageSize = list.size();
        int numPages = (int) Math.ceil((double)list.size() / (double)pageSize);
        List<List<T>> pages = new ArrayList<List<T>>(numPages);
        for (int pageNum = 0; pageNum < numPages;)
            pages.add(list.subList(pageNum * pageSize, Math.min(++pageNum * pageSize, list.size())));
        return pages;
    }
}

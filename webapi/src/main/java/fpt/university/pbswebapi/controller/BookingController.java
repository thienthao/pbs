package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.BookingWithWarningDetail;
import fpt.university.pbswebapi.dto.BookingWithWarningDto;
import fpt.university.pbswebapi.dto.CommentDto;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.BookingComment;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.CustomRepository;
import fpt.university.pbswebapi.security.services.UserDetailsImpl;
import fpt.university.pbswebapi.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
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
    private CustomRepository customRepository;

    @Autowired
    public BookingController(BookingService bookingService, BookingRepository bookingRepository, CustomRepository customRepository) {
        this.bookingService = bookingService;
        this.bookingRepository = bookingRepository;
        this.customRepository = customRepository;
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

    @GetMapping("/photographer/{photographerId}/with-warnings")
    public ResponseEntity<Map<String, Object>> getBookingWithWarningByStatusSortById(@RequestParam(defaultValue = "0") int page,
                                                                                     @RequestParam(defaultValue = "5") int size,
                                                                                     @PathVariable("photographerId") Long photographerId) {
        try {
            List<BookingWithWarningDto> bookings = new ArrayList<>();
            Pageable paging = PageRequest.of(page, size);

            Page<Booking> pageBookings;
            pageBookings = bookingService.findAllOfPhotographerByStatus(EBookingStatus.PENDING, paging, photographerId);

            bookings = bookingService.getWarning(pageBookings.getContent());
            Map<String, Object> response = new HashMap<>();
            response.put("data", bookings);
            response.put("currentPage", pageBookings.getNumber());
            response.put("totalItems", pageBookings.getTotalElements());
            response.put("totalPages", pageBookings.getTotalPages());

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Booking> getBookingById(@PathVariable Long id) {
        Booking booking = bookingRepository.findById(id).get();
        booking.setPhotographer(customRepository.findOne(booking.getPhotographer().getId()));
        return new ResponseEntity<>(booking, HttpStatus.OK);
    }

    @GetMapping("/with-warnings/{id}")
    public ResponseEntity<BookingWithWarningDetail> getBookingWithWarningById(@PathVariable Long id) {
        return new ResponseEntity<>(bookingService.findById(id), HttpStatus.OK);
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

    @PostMapping("/distance-warning")
    public ResponseEntity<?> warnDistance(@RequestBody Booking booking) {
        return new ResponseEntity<>(bookingService.warnDistance(booking), HttpStatus.OK);
    }

    @GetMapping("/time-warning")
    public ResponseEntity<?> warnTiming(@RequestParam("datetime") String datetime, @RequestParam("ptgId") Long ptgId) {
        return new ResponseEntity<>(bookingService.warnTiming(ptgId, datetime), HttpStatus.OK);
    }

    @GetMapping("/weather-warning")
    public ResponseEntity<?> warnWeather(@RequestParam("datetime") String datetime, @RequestParam("lat") Double lat, @RequestParam("lon") Double lon) {
        return new ResponseEntity<>(bookingService.getWeatherInfo(datetime, lat, lon), HttpStatus.OK);
    }

    @GetMapping("/test/weather-warning")
    public ResponseEntity<?> testWeather(@RequestParam("datetime") String datetime, @RequestParam("timeAnticipate") int timeAnticipate, @RequestParam("lat") Double lat, @RequestParam("lon") Double lon) {
        return new ResponseEntity<>(bookingService.getWeatherInfo(datetime, timeAnticipate, lat, lon), HttpStatus.OK);
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
        if (booking.getBookingStatus() != EBookingStatus.PENDING) {
            return ResponseEntity.badRequest().build();
        }
        return new ResponseEntity<Booking>(bookingService.cancelForCustomer(booking), HttpStatus.OK);
    }

    @PutMapping("/cancellation-submit/customer")
    public ResponseEntity<Booking> submitCancellationForCustomer(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.submitCancellationForCustomer(booking), HttpStatus.OK);
    }

    @PutMapping("/cancel/photographer")
    public ResponseEntity<Booking> cancelForPhotographer(@RequestBody Booking booking) {
        if (booking.getBookingStatus() != EBookingStatus.PENDING) {
            return ResponseEntity.badRequest().build();
        }
        return new ResponseEntity<Booking>(bookingService.cancelForPhotographer(booking), HttpStatus.OK);
    }

    @PutMapping("/cancellation-submit/photographer")
    public ResponseEntity<Booking> submitCancellationForPhotographer(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.submitCancellationForPhotographer(booking), HttpStatus.OK);
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

    @PutMapping("/re-editing")
    public ResponseEntity<Booking> reEditing(@RequestBody Booking booking) {
        return new ResponseEntity<Booking>(bookingService.reEditing(booking), HttpStatus.OK);
    }

    @PutMapping("/checkin/{bookingId}")
    public ResponseEntity<?> checkin(@PathVariable Long bookingId) {
        bookingService.checkin(bookingId);
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }

    @PutMapping("/checkin/{bookingId}/{tldId}")
    public ResponseEntity<?> checkinOnDate(@PathVariable Long bookingId, @PathVariable Long tldId) {
        bookingService.checkin(tldId);
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }

    @GetMapping(value = "/checkin/{bookingId}/{tldId}", produces = MediaType.IMAGE_PNG_VALUE)
    public byte[] getQRCheckInCode(@PathVariable Long bookingId, @PathVariable Long tldId) {
        return bookingService.getQRCheckInCode(bookingId, tldId);
    }

    @GetMapping("/ischeckin/{bookingId}")
    public ResponseEntity<?> isCheckin(@PathVariable Long bookingId) {
        return new ResponseEntity<>(bookingService.isCheckin(bookingId), HttpStatus.OK);
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

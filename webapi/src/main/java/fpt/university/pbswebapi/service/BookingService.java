package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.CommentDto;
import fpt.university.pbswebapi.dto.NotiRequest;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.helper.DtoMapper;
import fpt.university.pbswebapi.helper.MapHelper;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.CommentRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final FCMService fcmService;

    @Autowired
    public BookingService(BookingRepository bookingRepository, CommentRepository commentRepository, UserRepository userRepository, FCMService fcmService) {
        this.bookingRepository = bookingRepository;
        this.commentRepository = commentRepository;
        this.userRepository = userRepository;
        this.fcmService = fcmService;
    }

    public Booking checkDistance(Booking booking) {
        //query booking trong vong 1 ngay truoc va 1 ngay sau
        // vidu ngay` 25
        try {
            // lay bien thoi gian dau vo
            // TH1: booking 1 ngay
            if(booking.getServicePackage().getSupportMultiDays()) {
                TimeLocationDetail timeLocationDetail = booking.getTimeLocationDetails().get(0);
                String fromStr = timeLocationDetail.toString();
                String toStr = timeLocationDetail.toString();
            } else {

            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        // t = S / v
        // neu t < thoi gian tu bay gio cho toi thoi diem dat hen
        return null;
    }

    public Booking book(Booking booking) {
        Booking result = bookingRepository.save(booking);
        User user = userRepository.findById(booking.getCustomer().getId()).get();
        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Yêu cầu đặt hẹn mới");
        notiRequest.setBody("Bạn nhận được yêu cầu đặt hẹn từ " + user.getFullname());
        notiRequest.setToken(result.getPhotographer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId(), "photographer-topic");
        return result;
    }

    public Booking accept(Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 1");
//        }
        savedBooking.setBookingStatus(EBookingStatus.ONGOING);
        Booking result = bookingRepository.save(savedBooking);
        User user = userRepository.findById(booking.getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Đặt hẹn thành công");
        notiRequest.setBody(user.getFullname() + " đã chấp nhận yêu cầu từ bạn.");
        notiRequest.setToken(result.getPhotographer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId(), "topic");
        return result;
    }

    public Booking reject(Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 1");
//        }

        savedBooking.setBookingStatus(EBookingStatus.REJECTED);
        savedBooking.setRejectedReason(booking.getRejectedReason());
        Booking result = bookingRepository.save(savedBooking);

        User user = userRepository.findById(booking.getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Rất tiếc, đặt hẹn thất bại");
        notiRequest.setBody(user.getFullname() + " đã không thể chấp nhận yêu cầu từ bạn.");
        notiRequest.setToken(result.getCustomer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId(), "topic");
        return result;
    }

    public Booking cancelForCustomer(Booking booking) {
        // if status not hop ly
        // check co dung nguoi ko
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setBookingStatus(EBookingStatus.CANCELED);
        savedBooking.setCustomerCanceledReason(booking.getCustomerCanceledReason());
        savedBooking.setPhotographerCanceledReason(booking.getPhotographerCanceledReason());
        Booking result = bookingRepository.save(savedBooking);
        User user = userRepository.findById(booking.getCustomer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Rất tiếc, cuộc hẹn đã bị hủy");
        notiRequest.setBody(user.getFullname() + " đã hủy cuộc hẹn.");
        notiRequest.setToken(result.getPhotographer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId(), "photographer-topic");
        return result;
    }

    public Booking cancelForPhotographer(Booking booking) {
        // if status not hop ly
        // check co dung nguoi ko
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setBookingStatus(EBookingStatus.CANCELED);
        savedBooking.setCustomerCanceledReason(booking.getCustomerCanceledReason());
        savedBooking.setPhotographerCanceledReason(booking.getPhotographerCanceledReason());
        Booking result = bookingRepository.save(savedBooking);
        User user = userRepository.findById(booking.getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Rất tiếc, cuộc hẹn đã bị hủy");
        notiRequest.setBody(user.getFullname() + " đã hủy cuộc hẹn.");
        notiRequest.setToken(result.getCustomer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId(), "topic");
        return result;
    }

    public Booking editing(Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setBookingStatus(EBookingStatus.EDITING);
        Booking result = bookingRepository.save(savedBooking);
        return result;
    }

    public Booking done(Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setBookingStatus(EBookingStatus.DONE);
        savedBooking.setComment(booking.getComment());
        savedBooking.setRating(booking.getRating());
        Booking result = bookingRepository.save(savedBooking);

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Đơn chụp hình thành công");
        notiRequest.setBody("Đơn chụp hình với " + savedBooking.getPhotographer().getFullname() + " đã hoàn tất.");
        notiRequest.setToken(result.getCustomer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId(), "topic");

        return result;
    }

    public Page<Booking> findByStatus(EBookingStatus status, Pageable paging, Long userId) {
        return bookingRepository.byStatus(status, paging, userId);
    }

    public Page<Booking> findByStatusForCustomer(EBookingStatus status, Pageable paging, Long customerId) {
        return bookingRepository.byStatusForCustomer(status, paging, customerId);
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

    public List<String> warnBookingTime(Booking booking) {
        // booking nay` la pending booking
        List<String> warnings = new ArrayList<>();
        Integer duration = booking.getTimeAnticipate();
        for(TimeLocationDetail tld : booking.getTimeLocationDetails()) {
            //get cai booking do len da~
            Date startDate = tld.getStart(); //bien nay se de query cac booking trong 1 ngay hom do
            LocalDateTime localDateTime = DateHelper.convertToLocalDateTimeViaInstant(startDate);
            LocalDate startLocalDate = DateHelper.convertToLocalDateViaInstant(startDate);
            LocalDateTime atStart = startLocalDate.atStartOfDay();
            LocalDateTime atEnd = startLocalDate.atTime(23, 59);
            Date dateAtStart = DateHelper.convertToDateViaInstant(atStart);
            Date dateAtEnd = DateHelper.convertToDateViaInstant(atEnd);
            List<Booking> bookings = bookingRepository.findOngoingBookingOnDate(dateAtStart, dateAtEnd, booking.getPhotographer().getId());

            //start time + duration
            LocalTime pendingStartTime = localDateTime.toLocalTime();

            for(Booking onGoingBooking : bookings) {
                for (TimeLocationDetail timeLocationDetail : onGoingBooking.getTimeLocationDetails()) {
                    LocalDateTime ongoingStartDateTime = DateHelper.convertToLocalDateTimeViaInstant(timeLocationDetail.getStart());
                    LocalTime ongoingStartTime = ongoingStartDateTime.toLocalTime();
                    LocalTime ongoingEndTime = DateHelper.plusHour(ongoingStartTime, 3);
                    LocalTime onGoingEndTimePlus2 = DateHelper.plusHour(ongoingEndTime, 2);
                    if(pendingStartTime.compareTo(ongoingEndTime) > 0 && onGoingEndTimePlus2.compareTo(pendingStartTime) > 0) {
                        warnings.add("Bạn có lịch hẹn kết thúc vào lúc " + ongoingEndTime + " với " + onGoingBooking.getCustomer().getFullname() + "! Bạn có chắc muốn nhận cuộc hẹn này? ");
                    }
                }
            }
        }
        return warnings;
    }

    public List<String> warnDistance(Booking booking) {
        // booking nay` la pending booking
        List<String> warnings = new ArrayList<>();
        for(TimeLocationDetail tld : booking.getTimeLocationDetails()) {
            Date startDate = tld.getStart(); //bien nay se de query cac booking trong 1 ngay hom do
            LocalDateTime localDateTime = DateHelper.convertToLocalDateTimeViaInstant(startDate);
            LocalDate startLocalDate = DateHelper.convertToLocalDateViaInstant(startDate);
            LocalDateTime atStart = startLocalDate.atStartOfDay();
            atStart = atStart.minusDays(1);
            LocalDateTime atEnd = startLocalDate.atTime(23, 59);
            atEnd = atEnd.plusDays(1);
            Date dateAtStart = DateHelper.convertToDateViaInstant(atStart);
            Date dateAtEnd = DateHelper.convertToDateViaInstant(atEnd);
            List<Booking> bookings = bookingRepository.findOngoingBookingOnDate(dateAtStart, dateAtEnd, booking.getPhotographer().getId());

            Double pendingLat = tld.getLat();
            Double pendingLon = tld.getLon();

            for(Booking onGoingBooking : bookings) {
                for(TimeLocationDetail timeLocationDetail : onGoingBooking.getTimeLocationDetails()) {
                    Double onGoingLat = timeLocationDetail.getLat();
                    Double onGoingLon = timeLocationDetail.getLon();
                    Double distance = MapHelper.distance(pendingLat, onGoingLat, pendingLon, onGoingLon);
                    if(distance > 50) {
                        warnings.add("Khoảng cách giữa cuộc hẹn với " + onGoingBooking.getCustomer().getFullname() + " và cuộc hẹn này là " + distance +"! Bạn có chắc muốn nhận cuộc hẹn này? ");
                    }
                }
            }
        }
        return warnings;
    }
}

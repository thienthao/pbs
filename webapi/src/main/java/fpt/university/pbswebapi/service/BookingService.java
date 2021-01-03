package fpt.university.pbswebapi.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import fpt.university.pbswebapi.dto.*;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.*;
import fpt.university.pbswebapi.helper.weather.*;
import fpt.university.pbswebapi.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.DecimalFormat;
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
    private final NotificationService notificationService;
    private final CancellationRepository cancellationRepository;
    private final NotificationRepository notificationRepository;

    @Autowired
    public BookingService(BookingRepository bookingRepository, CommentRepository commentRepository, UserRepository userRepository, FCMService fcmService, NotificationService notificationService, CancellationRepository cancellationRepository, NotificationRepository notificationRepository) {
        this.bookingRepository = bookingRepository;
        this.commentRepository = commentRepository;
        this.userRepository = userRepository;
        this.fcmService = fcmService;
        this.notificationService = notificationService;
        this.cancellationRepository = cancellationRepository;
        this.notificationRepository = notificationRepository;
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
        booking.setCreatedAt(new Date());
        Booking result = bookingRepository.save(booking);
        User user = userRepository.findById(booking.getCustomer().getId()).get();
        User photographer = userRepository.findById(booking.getPhotographer().getId()).get();
        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Yêu cầu đặt hẹn mới");
        notiRequest.setBody("Bạn nhận được yêu cầu đặt hẹn từ " + user.getFullname());
        notiRequest.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        notificationService.requestPhotographerNotification(booking);

        return result;
    }

    public Booking accept(Booking booking) {
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();

        savedBooking.setBookingStatus(EBookingStatus.ONGOING);
        Booking result = bookingRepository.save(savedBooking);
        User user = userRepository.findById(booking.getPhotographer().getId()).get();
        User customer = userRepository.findById(booking.getCustomer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Đặt hẹn thành công");
        notiRequest.setBody(user.getFullname() + " đã chấp nhận yêu cầu từ bạn.");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        notificationService.createAcceptResultNotification(booking);

        return result;
    }

    public Booking reject(Booking booking) {
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();

        savedBooking.setBookingStatus(EBookingStatus.REJECTED);
        savedBooking.setRejectedReason(booking.getRejectedReason());
        Booking result = bookingRepository.save(savedBooking);

        User user = userRepository.findById(booking.getPhotographer().getId()).get();
        User customer = userRepository.findById(booking.getCustomer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Rất tiếc, đặt hẹn thất bại");
        notiRequest.setBody(user.getFullname() + " đã không thể chấp nhận yêu cầu từ bạn.");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        notificationService.createRejectResultNotification(booking);
        return result;
    }

    public Booking submitCancellationForCustomer(Booking booking) {
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();

        savedBooking.setUpdatedAt(new Date());
        savedBooking.setBookingStatus(EBookingStatus.CANCELLING_CUSTOMER);
        savedBooking.setCustomerCanceledReason(booking.getCustomerCanceledReason());
        Booking result = bookingRepository.save(savedBooking);
        User customer = userRepository.findById(booking.getCustomer().getId()).get();

        CancellationRequest cancellationRequest = new CancellationRequest();
        cancellationRequest.setBooking(result);
        cancellationRequest.setOwner(customer);
        cancellationRequest.setReason(booking.getCustomerCanceledReason());
        cancellationRepository.save(cancellationRequest);

        User photographer = userRepository.findById(booking.getPhotographer().getId()).get();
        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo, " + customer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notiRequest.setBody("Thông báo, " + customer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notiRequest.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        Notification notification = new Notification();
        notification.setReceiverId(photographer.getId());
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setTitle(customer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notification.setContent(customer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notification.setBookingId(result.getId());
        notificationRepository.save(notification);
        return result;
    }

    public Booking submitCancellationForPhotographer(Booking booking) {
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();

        savedBooking.setUpdatedAt(new Date());
        savedBooking.setBookingStatus(EBookingStatus.CANCELLING_PHOTOGRAPHER);
        savedBooking.setPhotographerCanceledReason(booking.getPhotographerCanceledReason());
        Booking result = bookingRepository.save(savedBooking);
        User photographer = userRepository.findById(booking.getPhotographer().getId()).get();

        CancellationRequest cancellationRequest = new CancellationRequest();
        cancellationRequest.setBooking(result);
        cancellationRequest.setOwner(photographer);
        cancellationRequest.setReason(booking.getPhotographerCanceledReason());
        cancellationRepository.save(cancellationRequest);

        User customer = userRepository.findById(booking.getCustomer().getId()).get();
        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo, " + photographer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notiRequest.setBody("Thông báo, " + photographer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        Notification notification = new Notification();
        notification.setReceiverId(customer.getId());
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setTitle(photographer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notification.setContent(photographer.getFullname() + " đã gửi yêu cầu hủy cuộc hẹn");
        notification.setBookingId(result.getId());
        notificationRepository.save(notification);
        return result;
    }

    public Booking cancelForCustomer(Booking booking) {
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();

        savedBooking.setUpdatedAt(new Date());
        savedBooking.setBookingStatus(EBookingStatus.CANCELED);
        savedBooking.setCustomerCanceledReason(booking.getCustomerCanceledReason());
        savedBooking.setPhotographerCanceledReason(booking.getPhotographerCanceledReason());
        Booking result = bookingRepository.save(savedBooking);
        User user = userRepository.findById(booking.getCustomer().getId()).get();
        User photographer = userRepository.findById(booking.getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Rất tiếc, cuộc hẹn đã bị hủy");
        notiRequest.setBody(user.getFullname() + " đã hủy cuộc hẹn.");
        notiRequest.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());
        return result;
    }

    public Booking cancelForPhotographer(Booking booking) {
        // if status not hop ly
        // check co dung nguoi ko
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setUpdatedAt(new Date());
        savedBooking.setBookingStatus(EBookingStatus.CANCELED);
        savedBooking.setCustomerCanceledReason(booking.getCustomerCanceledReason());
        savedBooking.setPhotographerCanceledReason(booking.getPhotographerCanceledReason());
        Booking result = bookingRepository.save(savedBooking);
        User user = userRepository.findById(booking.getPhotographer().getId()).get();
        User customer = userRepository.findById(booking.getCustomer().getId()).get();


        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Rất tiếc, cuộc hẹn đã bị hủy");
        notiRequest.setBody(user.getFullname() + " đã hủy cuộc hẹn.");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());
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

        User customer = userRepository.findById(booking.getCustomer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo");
        notiRequest.setBody(savedBooking.getPhotographer().getFullname() + " đang chỉnh sửa ảnh cho bạn.");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        notificationService.changeBookingStatusNotification(booking);

        return result;
    }

    public Booking reEditing(Booking booking) {
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setBookingStatus(EBookingStatus.EDITING);
        Booking result = bookingRepository.save(savedBooking);

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo");
        notiRequest.setBody(savedBooking.getCustomer().getFullname() + " thông báo chưa nhận được hình.");
        notiRequest.setToken(result.getCustomer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());
        return result;
    }

    public Booking done(Booking booking) {
        // if status not hop ly
        Booking savedBooking = bookingRepository.findById(booking.getId()).get();
//        if(isBookingOfUser(savedBooking.getPhotographer().getId()) == false && isBookingOfUser(savedBooking.getCustomer().getId()) == false) {
//            throw new BadRequestException("Booking not found - Code 2");
//        }

        savedBooking.setBookingStatus(EBookingStatus.DONE);
        savedBooking.setReturningLink(booking.getReturningLink());
        savedBooking.setComment(booking.getComment());
        savedBooking.setRating(booking.getRating());
        Booking result = bookingRepository.save(savedBooking);

        User customer = userRepository.findById(booking.getCustomer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Đơn chụp hình thành công");
        notiRequest.setBody("Đơn chụp hình với " + savedBooking.getPhotographer().getFullname() + " đã hoàn tất.");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());

        notificationService.changeBookingStatusNotification(booking);

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
                        warnings.add("Bạn có lịch hẹn kết thúc vào lúc " + ongoingEndTime + " với " + onGoingBooking.getCustomer().getFullname());
                    }
                }
            }
        }
        return warnings;
    }

    public List<String> warnTiming(Long ptgId, String datetime) {
        // booking nay` la pending booking
        List<String> warnings = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-ddHH:mm");
        LocalDateTime localDateTime = LocalDateTime.parse(datetime, formatter);
        Date startDate = DateHelper.convertToDateViaInstant(localDateTime);
        //get cai booking do len da~
        LocalDate startLocalDate = DateHelper.convertToLocalDateViaInstant(startDate);
        LocalDateTime atStart = startLocalDate.atStartOfDay();
        LocalDateTime atEnd = startLocalDate.atTime(23, 59);
        Date dateAtStart = DateHelper.convertToDateViaInstant(atStart);
        Date dateAtEnd = DateHelper.convertToDateViaInstant(atEnd);
        List<Booking> bookings = bookingRepository.findOngoingBookingOnDate(dateAtStart, dateAtEnd, ptgId);

        //start time + duration
        LocalTime pendingStartTime = localDateTime.toLocalTime();

        for(Booking onGoingBooking : bookings) {
            Integer duration = onGoingBooking.getTimeAnticipate();
            Integer hours = duration / 3600;
            for (TimeLocationDetail timeLocationDetail : onGoingBooking.getTimeLocationDetails()) {
                if(DateHelper.convertToLocalDateViaInstant(timeLocationDetail.getStart()).toString().equalsIgnoreCase(startLocalDate.toString())) {
                    LocalDateTime ongoingStartDateTime = DateHelper.convertToLocalDateTimeViaInstant(timeLocationDetail.getStart());
                    LocalTime ongoingStartTime = ongoingStartDateTime.toLocalTime();
                    LocalTime ongoingEndTime = DateHelper.plusHour(ongoingStartTime, hours);
                    LocalTime onGoingEndTimePlus2 = DateHelper.plusHour(ongoingEndTime, 2);
                    if(pendingStartTime.compareTo(ongoingEndTime) > 0 && onGoingEndTimePlus2.compareTo(pendingStartTime) > 0) {
                        warnings.add(ongoingEndTime + "," + onGoingBooking.getCustomer().getFullname());
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
                if(onGoingBooking.getId() != booking.getId()) {
                    for(TimeLocationDetail timeLocationDetail : onGoingBooking.getTimeLocationDetails()) {
                        Double onGoingLat = timeLocationDetail.getLat();
                        Double onGoingLon = timeLocationDetail.getLon();
                        Double distance = MapHelper.distance(pendingLat, onGoingLat, pendingLon, onGoingLon);
                        if(distance > 50) {
                            warnings.add(onGoingBooking.getCustomer().getFullname() + "," + new DecimalFormat("#.##").format(distance));
                        }
                    }
                }
            }
        }
        return warnings;
    }

    public List<String> warnWeather(String datetime, Double lat, Double lon) {
        WeatherNoti result = new WeatherNoti();
        List<String> results = new ArrayList<>();
        try {
            HttpClient httpClient = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_2)
                    .build();
            String url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                    "lat=" + lat + "&lon=" + lon + "&" +
                    "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                    "start_time="+datetime +"T09:00:00Z&apikey=LNwNBINAJLxv3FDkDpFKJ6Nen1cBRvpL";
            HttpRequest request = HttpRequest.newBuilder()
                    .GET()
                    .uri(URI.create(url))
                    .build();

            String outlook = "";
            String temperature = "";
            String humid = "";
            String wind = "";

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            ObjectMapper objectMapper = new ObjectMapper();
            Clima[] climas = objectMapper.readValue(response.body(), Clima[].class);
            for(int i = 0; i < climas.length; i++) {
//                mapTemp(climas[i].getTemp());
                Clima clima = climas[i];
                if(ClimaAPIHelper.mapDate(clima.getObservation()).equalsIgnoreCase(datetime)) {
                    Temp temp = ClimaAPIHelper.mapTemp(clima.getTemp());
                    Humidity humidity = ClimaAPIHelper.mapHumidity(clima.getHumidity());
                    WindSpeed windSpeed = ClimaAPIHelper.mapWindSpeed(clima.getWindSpeed());
                    temperature = ClimaAPIHelper.getTemp(temp);
                    humid = ClimaAPIHelper.getHumidity(humidity);
                    wind = ClimaAPIHelper.getWindSpeed(windSpeed);
                    outlook = ClimaAPIHelper.mapOutlook(clima.getCode());

                    WeatherBayesian ba = new WeatherBayesian();
                    ba.readTable();
                    result.setNoti(ba.compared(outlook, temperature, humid, wind));
                    result.setOutlook(outlook);
                    result.setTemperature(ClimaAPIHelper.getTempDouble(temp));
                    result.setHumidity(ClimaAPIHelper.getHumidityDouble(humidity));
                    result.setWindSpeed(ClimaAPIHelper.getWindSpeedDouble(windSpeed));
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }

        return results;
    }

    private HttpResponse<String> getWeatherResponse(Double lat, Double lon, String date) {
        HttpResponse<String> response = null;
        String apiKey1 = "LNwNBINAJLxv3FDkDpFKJ6Nen1cBRvpL";
        String apiKey2 = "LNi5rDEQAC5YoagsDYJJckE2g2eLfUgp";
        String apiKey3 = "nDVs44XgBuVQLHARVgHnB1JCmJQuRp8E";
        try {
            HttpClient httpClient = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_2)
                    .build();
            String url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                    "lat=" + lat + "&lon=" + lon + "&" +
                    "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                    "start_time="+ date +"T09:00:00&apikey=" + apiKey1;
            HttpRequest request = HttpRequest.newBuilder()
                    .GET()
                    .uri(URI.create(url))
                    .build();

            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if(response.statusCode() != 200) {
                url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                        "lat=" + lat + "&lon=" + lon + "&" +
                        "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                        "start_time="+ date +"T09:00:00&apikey=" + apiKey2;
                request = HttpRequest.newBuilder()
                        .GET()
                        .uri(URI.create(url))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

                if (response.statusCode() != 200) {
                    url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                            "lat=" + lat + "&lon=" + lon + "&" +
                            "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                            "start_time="+ date +"T09:00:00&apikey=" + apiKey3;
                    request = HttpRequest.newBuilder()
                            .GET()
                            .uri(URI.create(url))
                            .build();

                    response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
                }
            }
        } catch (Exception e) {
            System.out.println(e);
            try {
                HttpClient httpClient = HttpClient.newBuilder()
                        .version(HttpClient.Version.HTTP_2)
                        .build();
                String url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                        "lat=" + lat + "&lon=" + lon + "&" +
                        "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                        "start_time="+ date +"T09:00:00&apikey=" + apiKey3;
                HttpRequest request = HttpRequest.newBuilder()
                        .GET()
                        .uri(URI.create(url))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return response;
    }

    public List<String> warnWeather(Booking booking) {
        List<String> results = new ArrayList<>();
        for (TimeLocationDetail tld : booking.getTimeLocationDetails()) {
            try {
                String outlook = "";
                String temperature = "";
                String humid = "";
                String wind = "";

                HttpResponse<String> response = getWeatherResponse(tld.getLat(), tld.getLon(), DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString());
                ObjectMapper objectMapper = new ObjectMapper();
                Clima[] climas = objectMapper.readValue(response.body(), Clima[].class);
                for(int i = 0; i < climas.length; i++) {
//                mapTemp(climas[i].getTemp());
                    Clima clima = climas[i];
                    if(ClimaAPIHelper.mapDate(clima.getObservation()).equalsIgnoreCase(DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString())) {
                        Temp temp = ClimaAPIHelper.mapTemp(clima.getTemp());
                        Humidity humidity = ClimaAPIHelper.mapHumidity(clima.getHumidity());
                        WindSpeed windSpeed = ClimaAPIHelper.mapWindSpeed(clima.getWindSpeed());
                        temperature = ClimaAPIHelper.getTemp(temp);
                        humid = ClimaAPIHelper.getHumidity(humidity);
                        wind = ClimaAPIHelper.getWindSpeed(windSpeed);
                        outlook = ClimaAPIHelper.mapOutlook(clima.getCode());

                        WeatherBayesian ba = new WeatherBayesian();
                        ba.readTable();
                        String result = ba.comparedForDetail(outlook, temperature, humid, wind, DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString());
                        if(result != null)
                        results.add(result);
                    }
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        return results;
    }

    public List<WeatherNoti> warnWeatherForDetail(Booking booking) {
        List<WeatherNoti> results = new ArrayList<>();
        for (TimeLocationDetail tld : booking.getTimeLocationDetails()) {
            try {
                String outlook = "";
                String temperature = "";
                String humid = "";
                String wind = "";

                HttpResponse<String> response = getWeatherResponse(tld.getLat(), tld.getLon(), DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString());
                ObjectMapper objectMapper = new ObjectMapper();
                Clima[] climas = objectMapper.readValue(response.body(), Clima[].class);
                for(int i = 0; i < climas.length; i++) {
//                mapTemp(climas[i].getTemp());
                    Clima clima = climas[i];
                    if(ClimaAPIHelper.mapDate(clima.getObservation()).equalsIgnoreCase(DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString())) {
                        Temp temp = ClimaAPIHelper.mapTemp(clima.getTemp());
                        Humidity humidity = ClimaAPIHelper.mapHumidity(clima.getHumidity());
                        WindSpeed windSpeed = ClimaAPIHelper.mapWindSpeed(clima.getWindSpeed());
                        temperature = ClimaAPIHelper.getTemp(temp);
                        humid = ClimaAPIHelper.getHumidity(humidity);
                        wind = ClimaAPIHelper.getWindSpeed(windSpeed);
                        outlook = ClimaAPIHelper.mapOutlook(clima.getCode());

                        WeatherBayesian ba = new WeatherBayesian();
                        ba.readTable();
                        WeatherNoti result = new WeatherNoti();
                        String noti = ba.comparedForDetail(outlook, temperature, humid, wind, DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString());
                        if(noti != null) {
                            result.setNoti(noti);
                            result.setOutlook(outlook);
                            result.setTemperature(ClimaAPIHelper.getTempDouble(temp));
                            result.setHumidity(ClimaAPIHelper.getHumidityDouble(humidity));
                            result.setWindSpeed(ClimaAPIHelper.getWindSpeedDouble(windSpeed));
                            results.add(result);
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        return results;
    }

    public WeatherNoti getWeatherInfo(String datetime, Double lat, Double lon) {
        WeatherNoti result = new WeatherNoti();
        try {
            String outlook = "";
            String temperature = "";
            String humid = "";
            String wind = "";

            HttpResponse<String> response = getWeatherResponse(lat, lon, datetime);
            ObjectMapper objectMapper = new ObjectMapper();
            Clima[] climas = objectMapper.readValue(response.body(), Clima[].class);
            for(int i = 0; i < climas.length; i++) {
//                mapTemp(climas[i].getTemp());
                Clima clima = climas[i];
                if(ClimaAPIHelper.mapDate(clima.getObservation()).equalsIgnoreCase(datetime)) {
                    Temp temp = ClimaAPIHelper.mapTemp(clima.getTemp());
                    Humidity humidity = ClimaAPIHelper.mapHumidity(clima.getHumidity());
                    WindSpeed windSpeed = ClimaAPIHelper.mapWindSpeed(clima.getWindSpeed());
                    temperature = ClimaAPIHelper.getTemp(temp);
                    humid = ClimaAPIHelper.getHumidity(humidity);
                    wind = ClimaAPIHelper.getWindSpeed(windSpeed);
                    outlook = ClimaAPIHelper.mapOutlook(clima.getCode());

                    WeatherBayesian ba = new WeatherBayesian();
                    ba.readTable();
                    result.setNoti(ba.compared(outlook, temperature, humid, wind));
                    result.setOutlook(outlook);
                    result.setTemperature(ClimaAPIHelper.getTempDouble(temp));
                    result.setHumidity(ClimaAPIHelper.getHumidityDouble(humidity));
                    result.setWindSpeed(ClimaAPIHelper.getWindSpeedDouble(windSpeed));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e);
        }

        return result;
    }

    public BookingWithWarningDetail findById(Long id) {
        BookingWithWarningDetail result = new BookingWithWarningDetail();
        Booking booking = bookingRepository.findById(id).get();
        result.setBooking(booking);
        List<String> timeWarning = new ArrayList<>();
        for(TimeLocationDetail timeLocationDetail : booking.getTimeLocationDetails()) {
            timeWarning.addAll(warnTiming(booking.getPhotographer().getId(), DateHelper.convertToLocalDateTimeViaInstant(timeLocationDetail.getStart())));
        }
        result.setTimeWarnings(timeWarning);

        List<String> distanceWarning = warnDistance(booking);
        result.setDistanceWarning(distanceWarning);

        List<WeatherNoti> weatherWarning = warnWeatherForDetail(booking);
        result.setWeatherWarning(weatherWarning);

        List<String> selfWarning = selfWarnDistance(booking);
        result.setSelfWarnDistance(selfWarning);
        return result;
    }

    private BookingWithWarningDto getWarning(Booking booking) {
        BookingWithWarningDto result = new BookingWithWarningDto();

        result.setBooking(booking);
        List<String> timeWarning = new ArrayList<>();
        for(TimeLocationDetail timeLocationDetail : booking.getTimeLocationDetails()) {
            timeWarning.addAll(warnTiming(booking.getPhotographer().getId(), DateHelper.convertToLocalDateTimeViaInstant(timeLocationDetail.getStart())));
        }
        result.setTimeWarnings(timeWarning);

        List<String> distanceWarning = warnDistance(booking);
        result.setDistanceWarning(distanceWarning);

        List<String> weatherWarning = warnWeather(booking);
        result.setWeatherWarning(weatherWarning);

        List<String> selfDistanceWarning = selfWarnDistance(booking);
        result.setSelfWarnDistance(selfDistanceWarning);
        return result;
    }

    private List<String> selfWarnDistance(Booking booking) {
        List<String> results = new ArrayList<>();
        for(int i = 0; i < booking.getTimeLocationDetails().size(); i++) {
            for(int j = i + 1; j < booking.getTimeLocationDetails().size(); j++) {
                TimeLocationDetail tld = booking.getTimeLocationDetails().get(i);
                TimeLocationDetail tld1 = booking.getTimeLocationDetails().get(j);
                if(tld != tld1) {
                    Double tldLat = tld.getLat();
                    Double tldLon = tld.getLon();
                    Double tld1Lat = tld1.getLat();
                    Double tld1Long = tld1.getLon();
                    Double distance = MapHelper.distance(tldLat, tld1Lat, tldLon, tld1Long);
                    if(distance > 50) {
                        results.add("Khoảng cách giữa ngày " + DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString() + " và ngày " + DateHelper.convertToLocalDateViaInstant(tld1.getStart()).toString() + " là : " + NumberHelper.format(distance) + "km");
                    }
                }
            }
        }
        return results;
    }

    public List<BookingWithWarningDto> getWarning(List<Booking> bookings) {
        List<BookingWithWarningDto> result = new ArrayList<>();
        for (Booking booking : bookings) {
            result.add(getWarning(booking));
        }
        return result;
    }

    public List<String> warnTiming(Long ptgId, LocalDateTime localDateTime) {
        // booking nay` la pending booking
        List<String> warnings = new ArrayList<>();

        Date startDate = DateHelper.convertToDateViaInstant(localDateTime);
        //get cai booking do len da~
        LocalDate startLocalDate = DateHelper.convertToLocalDateViaInstant(startDate);
        LocalDateTime atStart = startLocalDate.atStartOfDay();
        LocalDateTime atEnd = startLocalDate.atTime(23, 59);
        Date dateAtStart = DateHelper.convertToDateViaInstant(atStart);
        Date dateAtEnd = DateHelper.convertToDateViaInstant(atEnd);
        List<Booking> bookings = bookingRepository.findOngoingBookingOnDate(dateAtStart, dateAtEnd, ptgId);

        //start time + duration
        LocalTime pendingStartTime = localDateTime.toLocalTime();

        for(Booking onGoingBooking : bookings) {
            Integer duration = onGoingBooking.getTimeAnticipate();
            Integer hour = duration / 3600;
            for (TimeLocationDetail timeLocationDetail : onGoingBooking.getTimeLocationDetails()) {
                LocalDateTime ongoingStartDateTime = DateHelper.convertToLocalDateTimeViaInstant(timeLocationDetail.getStart());
                LocalTime ongoingStartTime = ongoingStartDateTime.toLocalTime();
                LocalTime ongoingEndTime = DateHelper.plusHour(ongoingStartTime, hour);
                LocalTime onGoingEndTimePlus2 = DateHelper.plusHour(ongoingEndTime, 2);
                if(pendingStartTime.compareTo(ongoingEndTime) > 0 && onGoingEndTimePlus2.compareTo(pendingStartTime) > 0) {
                    warnings.add("Bạn có lịch hẹn trước kết thúc vào lúc " + ongoingEndTime + " với " + onGoingBooking.getCustomer().getFullname());
                }
            }
        }
        return warnings;
    }

    public List<Booking> getAllPending() {
        return bookingRepository.findAllPendingStatus();
    }
}

package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.NotiRequest;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.CustomRepository;
import fpt.university.pbswebapi.repository.NotificationRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.Date;
import java.util.List;

@Service
public class CronJobService {
    private static final Logger logger = LoggerFactory.getLogger(CronJobService.class);

    private BookingService bookingService;
    private BookingRepository bookingRepository;
    private FCMService fcmService;
    private CustomRepository customRepository;
    private UserRepository userRepository;
    private NotificationRepository notificationRepository;

    @Autowired
    public CronJobService(BookingService bookingService, BookingRepository bookingRepository, FCMService fcmService, CustomRepository customRepository, UserRepository userRepository, NotificationRepository notificationRepository) {
        this.bookingService = bookingService;
        this.bookingRepository = bookingRepository;
        this.fcmService = fcmService;
        this.customRepository = customRepository;
        this.userRepository = userRepository;
        this.notificationRepository = notificationRepository;
    }

    @Scheduled(fixedRate=60*60*1000)
    public void checkPendingBooking() {
        try {
            List<Booking> pendings = bookingService.getAllPending();
            for (Booking pending : pendings) {
                LocalDate createdAt = DateHelper.convertToLocalDateViaInstant(pending.getCreatedAt());
                LocalDate now = LocalDate.now();
                Period diff = Period.between(now, createdAt);
                if(diff.getDays() == 1) {
                    pending.setBookingStatus(EBookingStatus.CANCELED);
                    pending.setPhotographerCanceledReason("Không hồi âm");
                    pending.setUpdatedAt(new Date());
                    bookingRepository.save(pending);

                    NotiRequest notiRequest = new NotiRequest();
                    notiRequest.setTitle("Lịch hẹn đã bị hủy vì Photographer không hồi âm");
                    notiRequest.setBody("Lịch hẹn với " + pending.getPhotographer().getFullname() + " đã bị hủy vì không hồi âm");
                    notiRequest.setToken(pending.getCustomer().getDeviceToken());
                    fcmService.pushNotification(notiRequest, pending.getId(), "topic");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "${app.batch.cron.booking_remind_cron_7}")
    public void sendBookingRemindAt7() {
        logger.info("07:00 notify");
        List<Booking> ongoings = customRepository.getOngoingBookingFrom1201To2359();
        List<Booking> editings = customRepository.getEditingBookingFrom1201To2359();
        for(int i = 0; i < ongoings.size(); i++) {
            Booking booking = ongoings.get(i);
            User customer = booking.getCustomer();
            User photographer = booking.getPhotographer();
            try {
                NotiRequest notiRequest = new NotiRequest();
                notiRequest.setToken(booking.getPhotographer().getDeviceToken());
                notiRequest.setTitle("Nhắc hẹn");
                notiRequest.setBody("Bạn có lịch hẹn với " + customer.getFullname() + " vào ngày mai, chúc bạn một buổi chụp suôn sẻ!");
                fcmService.pushNotification(notiRequest, booking.getId());

                Notification notification1 = new Notification();
                notification1.setBookingId(booking.getId());
                notification1.setReceiverId(photographer.getId());
                notification1.setTitle("Nhắc hẹn");
                notification1.setTitle("Bạn có lịch hẹn với " + customer.getFullname() + " vào ngày mai, chúc bạn một buổi chụp suôn sẻ!");
                notification1.setNotificationType(ENotificationType.TIME_NOTIFICATION);
                notificationRepository.save(notification1);

                notiRequest.setToken(booking.getCustomer().getDeviceToken());
                notiRequest.setTitle("Nhắc hẹn");
                notiRequest.setBody("Bạn có lịch hẹn với " + photographer.getFullname() + " vào ngày mai, chúc bạn một buổi chụp suôn sẻ!");
                fcmService.pushNotification(notiRequest, booking.getId());

                Notification notification2 = new Notification();
                notification2.setBookingId(booking.getId());
                notification2.setReceiverId(customer.getId());
                notification2.setTitle("Nhắc hẹn");
                notification2.setTitle("Bạn có lịch hẹn với " + photographer.getFullname() + " vào ngày mai, chúc bạn một buổi chụp suôn sẻ!");
                notification2.setNotificationType(ENotificationType.TIME_NOTIFICATION);
                notificationRepository.save(notification2);
                logger.info("noti ongoing for " + booking.getId());
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }

        for(int i = 0; i < editings.size(); i++) {
            Booking booking = editings.get(i);
            User customer = booking.getCustomer();
            try {
                NotiRequest notiRequest = new NotiRequest();
                notiRequest.setToken(booking.getPhotographer().getDeviceToken());
                notiRequest.setTitle("Nhắc hẹn");
                notiRequest.setBody("Bạn có hẹn trả ảnh với " + customer.getFullname() + " vào ngày mai!");
                fcmService.pushNotification(notiRequest, booking.getId());

                Notification notification2 = new Notification();
                notification2.setBookingId(booking.getId());
                notification2.setReceiverId(customer.getId());
                notification2.setTitle("Nhắc hẹn");
                notification2.setTitle("Bạn có hẹn trả ảnh với " + customer.getFullname() + " vào ngày mai!");
                notification2.setNotificationType(ENotificationType.TIME_NOTIFICATION);
                notificationRepository.save(notification2);
                logger.info("noti editing for " + booking.getId());
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    @Scheduled(cron = "${app.batch.cron.booking_remind_cron_21}")
    public void sendBookingRemindAt21() {
        logger.info("21:00 notify");
        List<Booking> ongoings = customRepository.getOngoingBookingFrom00To12();
        List<Booking> editings = customRepository.getEditingBookingFrom00To12();
        for(int i = 0; i < ongoings.size(); i++) {
            Booking booking = ongoings.get(i);
            User customer = booking.getCustomer();
            User photographer = booking.getPhotographer();
            try {
                NotiRequest notiRequest = new NotiRequest();
                notiRequest.setToken(booking.getPhotographer().getDeviceToken());
                notiRequest.setTitle("Nhắc hẹn");
                notiRequest.setBody("Bạn có lịch hẹn với " + customer.getFullname() + " vào hôm nay, chúc bạn một buổi chụp suôn sẻ!");
                fcmService.pushNotification(notiRequest, booking.getId());

                Notification notification1 = new Notification();
                notification1.setBookingId(booking.getId());
                notification1.setReceiverId(photographer.getId());
                notification1.setTitle("Nhắc hẹn");
                notification1.setTitle("Bạn có lịch hẹn với " + customer.getFullname() + " vào hôm nay, chúc bạn một buổi chụp suôn sẻ!");
                notification1.setNotificationType(ENotificationType.TIME_NOTIFICATION);
                notificationRepository.save(notification1);

                notiRequest.setToken(booking.getCustomer().getDeviceToken());
                notiRequest.setTitle("Nhắc hẹn");
                notiRequest.setBody("Bạn có lịch hẹn với " + photographer.getFullname() + " vào hôm nay, chúc bạn một buổi chụp suôn sẻ!");
                fcmService.pushNotification(notiRequest, booking.getId());

                Notification notification2 = new Notification();
                notification2.setBookingId(booking.getId());
                notification2.setReceiverId(customer.getId());
                notification2.setTitle("Nhắc hẹn");
                notification2.setTitle("Bạn có lịch hẹn với " + photographer.getFullname() + " vào hôm nay, chúc bạn một buổi chụp suôn sẻ!");
                notification2.setNotificationType(ENotificationType.TIME_NOTIFICATION);
                notificationRepository.save(notification2);
                logger.info("noti ongoing for " + booking.getId());
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }

        for(int i = 0; i < editings.size(); i++) {
            Booking booking = editings.get(i);
            User customer = booking.getCustomer();
            try {
                NotiRequest notiRequest = new NotiRequest();
                notiRequest.setToken(booking.getPhotographer().getDeviceToken());
                notiRequest.setTitle("Nhắc hẹn");
                notiRequest.setBody("Bạn có hẹn trả ảnh với " + customer.getFullname() + " vào hôm nay!");
                fcmService.pushNotification(notiRequest, booking.getId());

                Notification notification1 = new Notification();
                notification1.setBookingId(booking.getId());
                notification1.setReceiverId(booking.getPhotographer().getId());
                notification1.setTitle("Nhắc hẹn");
                notification1.setTitle("Bạn có hẹn trả ảnh với " + customer.getFullname() + " vào hôm nay!");
                notification1.setNotificationType(ENotificationType.TIME_NOTIFICATION);
                notificationRepository.save(notification1);
                logger.info("noti editing for " + booking.getId());
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }
    }

    @Scheduled(cron = "${app.batch.cron.booking_pending_cron}")
    public void setExpiredPendingBookingAfter24Hours() {
        logger.info("Set expired pending bookings");
        customRepository.setExpiredPendingBookingAfter24Hours();
    }
}

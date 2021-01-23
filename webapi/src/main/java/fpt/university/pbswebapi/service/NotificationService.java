package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.NotiRequest;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.ENotificationType;
import fpt.university.pbswebapi.entity.Notification;
import fpt.university.pbswebapi.helper.ThymeleafHelper;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final BookingRepository bookingRepository;
    private final FCMService fcmService;

    @Autowired
    public NotificationService(NotificationRepository notificationRepository, BookingRepository bookingRepository, FCMService fcmService) {
        this.notificationRepository = notificationRepository;
        this.bookingRepository = bookingRepository;
        this.fcmService = fcmService;
    }

    public List<Notification> findNotiWhereUserId(Long receiverId) {
        return notificationRepository.getAllByReceiverIdAndIsReadFalseOrderByCreatedAtDesc(receiverId);
    }

    public void createAcceptResultNotification(Booking booking) {
        Notification notification = new Notification();
        notification.setTitle(booking.getPhotographer().getFullname() + " đã chấp nhận yêu cầu từ bạn");
        notification.setNotificationType(ENotificationType.REQUEST_RESULT);
        notification.setBookingId(booking.getId());
        notification.setCreatedAt(new Date());
        notification.setReceiverId(booking.getCustomer().getId());
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    public void createRejectResultNotification(Booking booking) {
        Notification notification = new Notification();
        notification.setTitle(booking.getPhotographer().getFullname() + " đã từ chối yêu cầu từ bạn");
        notification.setNotificationType(ENotificationType.REQUEST_RESULT);
        notification.setBookingId(booking.getId());
        notification.setCreatedAt(new Date());
        notification.setReceiverId(booking.getCustomer().getId());
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    public void changeBookingStatusNotification(Booking booking) {
        Notification notification = new Notification();
        notification.setTitle("Đơn hẹn với " + booking.getPhotographer().getFullname() + " đã chuyển sang trạng thái " + ThymeleafHelper.convertStatus(booking.getBookingStatus().toString()));
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setBookingId(booking.getId());
        notification.setCreatedAt(new Date());
        notification.setReceiverId(booking.getCustomer().getId());
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    public void requestPhotographerNotification(Booking booking, String customerFullname) {
        Notification notification = new Notification();
        notification.setTitle(customerFullname + " đã gửi yêu cầu cho bạn");
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setBookingId(booking.getId());
        notification.setCreatedAt(new Date());
        notification.setReceiverId(booking.getPhotographer().getId());
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    public void setIsReadTrue(Long id) {
        notificationRepository.setIsRead(id);
    }

    public void createConfirmationNotification(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId).get();

        Notification notification = new Notification();
        notification.setTitle(booking.getPhotographer().getFullname() + " đã gửi yêu cầu xác nhận gặp mặt");
        notification.setContent("Có vẻ buổi chụp với " + booking.getPhotographer().getFullname() + " đã kết thúc, tuy nhiên Photographer đã quên check in, xin bạn hãy xác nhận thay Photographer");
        notification.setNotificationType(ENotificationType.CONFIRMATION_REQUEST);
        notification.setBookingId(booking.getId());
        notification.setCreatedAt(new Date());
        notification.setReceiverId(booking.getCustomer().getId());
        notification.setIsRead(false);
        notificationRepository.save(notification);

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Xác nhận cuộc hẹn");
        notiRequest.setBody(booking.getPhotographer().getFullname() + " đã gửi yêu cầu xác nhận buổi chụp đã hoàn thành.");
        notiRequest.setToken(booking.getCustomer().getDeviceToken());
        fcmService.pushNotification(notiRequest, booking.getId());
    }
}
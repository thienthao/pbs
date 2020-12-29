package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.ENotificationType;
import fpt.university.pbswebapi.entity.Notification;
import fpt.university.pbswebapi.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;

    @Autowired
    public NotificationService(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    public List<Notification> findNotiWhereUserId(Long receiverId) {
        return notificationRepository.getAllByReceiverId(receiverId);
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
        notification.setTitle("Đơn hẹn với " + booking.getPhotographer().getFullname() + " đã chuyển sang trạng thái " + booking.getBookingStatus().toString());
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setBookingId(booking.getId());
        notification.setCreatedAt(new Date());
        notification.setReceiverId(booking.getCustomer().getId());
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    public void requestPhotographerNotification(Booking booking) {
        Notification notification = new Notification();
        notification.setTitle(booking.getCustomer().getFullname() + " đã gửi yêu cầu cho bạn");
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
}

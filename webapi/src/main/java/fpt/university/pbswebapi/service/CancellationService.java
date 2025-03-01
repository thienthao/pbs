package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.AccountVerificationEmailContext;
import fpt.university.pbswebapi.dto.NotiRequest;
import fpt.university.pbswebapi.dto.WarningEmailContext;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.CancellationRepository;
import fpt.university.pbswebapi.repository.NotificationRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Properties;

@Service
public class CancellationService {

    private final CancellationRepository cancellationRepository;
    private final UserRepository userRepository;
    private final NotificationRepository notificationRepository;
    private final FCMService fcmService;
    private final BookingRepository bookingRepository;
    private final EmailService emailService;

    @Autowired
    public CancellationService(CancellationRepository cancellationRepository, UserRepository userRepository, NotificationRepository notificationRepository, FCMService fcmService, BookingRepository bookingRepository, EmailService emailService) {
        this.cancellationRepository = cancellationRepository;
        this.userRepository = userRepository;
        this.notificationRepository = notificationRepository;
        this.fcmService = fcmService;
        this.bookingRepository = bookingRepository;
        this.emailService = emailService;
    }

    private Page<CancellationRequest> getAllSolve(Pageable pageable) {
        return cancellationRepository.findAllByIsSolveTrue(pageable);
    }

    private Page<CancellationRequest> getByDateSolve(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return cancellationRepository.findAllByDateSolve(from, to, pageable);
    }

    private Page<CancellationRequest> getAllNotSolve(Pageable pageable) {
        return cancellationRepository.findAllByIsSolveFalse(pageable);
    }

    private Page<CancellationRequest> getByDateNotSolve(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return cancellationRepository.findAllByDateNotSolve(from, to, pageable);
    }

    private Page<CancellationRequest> getAllByDate(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return cancellationRepository.findAllByDate(from, to, pageable);
    }

    public Page<CancellationRequest> getCancellations(Pageable pageable, String start, String end, String filter) {
        switch (filter) {
            case "not_solve":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllNotSolve(pageable);
                }
                return getByDateNotSolve(pageable, start, end);
            case "solve":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllSolve(pageable);
                }
                return getByDateSolve(pageable, start, end);
            case "all":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return cancellationRepository.findAll(pageable);
                }
                return getAllByDate(pageable, start, end);
            default:
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllNotSolve(pageable);
                }
                return getByDateNotSolve(pageable, start, end);
        }
    }

    public boolean isBookingHasCancellation(Long bookingId) {
        if(cancellationRepository.countCancellation(bookingId) > 0) {
            return true;
        }
        return false;
    }


    public Object findById(Long id) {
        return cancellationRepository.findById(id).get();
    }

    private void noti(CancellationRequest cancellationRequest) {
        User customer = userRepository.findById(cancellationRequest.getBooking().getCustomer().getId()).get();
        User photographer = userRepository.findById(cancellationRequest.getBooking().getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notiRequest.setBody("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, cancellationRequest.getBooking().getId());

        NotiRequest notiRequest1 = new NotiRequest();
        notiRequest1.setTitle("Thông báo, cuộc hẹn với " + customer.getFullname() + " đã bị hủy");
        notiRequest1.setBody("Thông báo, cuộc hẹn với " + customer.getFullname() + " đã bị hủy");
        notiRequest1.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest1, cancellationRequest.getBooking().getId());

        Notification notification = new Notification();
        notification.setReceiverId(customer.getId());
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setTitle("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notification.setContent("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notification.setBookingId(cancellationRequest.getBooking().getId());
        notificationRepository.save(notification);

        Notification notification1 = new Notification();
        notification1.setReceiverId(photographer.getId());
        notification1.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification1.setTitle("Thông báo, cuộc hẹn với " + customer.getFullname() + " đã bị hủy");
        notification1.setContent("Thông báo, cuộc hẹn với " + customer.getFullname() + " đã bị hủy");
        notification1.setBookingId(cancellationRequest.getBooking().getId());
        notificationRepository.save(notification1);
    }

    public void approve(Long id) {
        CancellationRequest cancellationRequest = cancellationRepository.findById(id).get();
        cancellationRequest.setIsSolve(true);
        cancellationRequest.setApprovedAt(new Date());
        cancellationRepository.save(cancellationRequest);
        if(cancellationRequest.getOwner().getRole().getRole() == ERole.ROLE_CUSTOMER) {
            Booking savedBooking = bookingRepository.findById(cancellationRequest.getBooking().getId()).get();
            savedBooking.setPreviousStatus(savedBooking.getBookingStatus());
            savedBooking.setBookingStatus(EBookingStatus.CANCELLED_CUSTOMER);
            savedBooking.setUpdatedAt(new Date());
            bookingRepository.save(savedBooking);
            noti(cancellationRequest);
        } else {
            Booking savedBooking = bookingRepository.findById(cancellationRequest.getBooking().getId()).get();
            savedBooking.setPreviousStatus(savedBooking.getBookingStatus());
            savedBooking.setBookingStatus(EBookingStatus.CANCELLED_PHOTOGRAPHER);
            savedBooking.setUpdatedAt(new Date());
            bookingRepository.save(savedBooking);
            noti(cancellationRequest);
        }
    }

    public void warn(Long id, String mail) {
        CancellationRequest cancellationRequest = cancellationRepository.findById(id).get();
        if(cancellationRequest.getOwner().getRole().getRole() == ERole.ROLE_CUSTOMER) {
//            mailCustomer(cancellationRequest);
//            warnCustomer(cancellationRequest);
//            informPhotographerAboutWarnedCustomer(cancellationRequest);
        } else {
//            mailPhotographer(cancellationRequest);
//            warnPhotographer(cancellationRequest);
//            informCustomerAboutWarnedPhotographer(cancellationRequest);
        }
        try {
            WarningEmailContext emailContext = new WarningEmailContext();
            emailContext.init(cancellationRequest.getOwner());
            emailContext.buildEmailContent(cancellationRequest.getOwner().getFullname());
            emailService.sendMail(emailContext);
        } catch (Exception e) {
            e.printStackTrace();
        }
        cancellationRequest.setIsSolve(true);
        cancellationRepository.save(cancellationRequest);
        Booking booking = bookingRepository.findById(cancellationRequest.getBooking().getId()).get();
        booking.setPreviousStatus(booking.getBookingStatus());
        booking.setBookingStatus(EBookingStatus.CANCELLED_ADMIN);
        bookingRepository.save(booking);
    }

    private void informCustomerAboutWarnedPhotographer(CancellationRequest cancellationRequest) {
        User customer = userRepository.findById(cancellationRequest.getBooking().getCustomer().getId()).get();
        User photographer = userRepository.findById(cancellationRequest.getBooking().getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notiRequest.setBody("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notiRequest.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest, cancellationRequest.getBooking().getId());

        NotiRequest notiRequest1 = new NotiRequest();
        notiRequest1.setTitle("Cuộc hẹn với " + photographer.getFullname() + " đã bị hủy! Tuy nhiên " + photographer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notiRequest1.setBody("Cuộc hẹn với " + photographer.getFullname() + " đã bị hủy! Tuy nhiên " + photographer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notiRequest1.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest1, cancellationRequest.getBooking().getId());

        Notification notification1 = new Notification();
        notification1.setReceiverId(customer.getId());
        notification1.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification1.setTitle("Cuộc hẹn với " + photographer.getFullname() + " đã bị hủy! Tuy nhiên " + photographer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notification1.setContent("Cuộc hẹn với " + photographer.getFullname() + " đã bị hủy! Tuy nhiên " + photographer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notification1.setBookingId(cancellationRequest.getBooking().getId());
        notificationRepository.save(notification1);
    }

    private void informPhotographerAboutWarnedCustomer(CancellationRequest cancellationRequest) {
        User customer = userRepository.findById(cancellationRequest.getBooking().getCustomer().getId()).get();
        User photographer = userRepository.findById(cancellationRequest.getBooking().getPhotographer().getId()).get();

        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notiRequest.setBody("Thông báo, cuộc hẹn với " + photographer.getFullname() + " đã bị hủy");
        notiRequest.setToken(customer.getDeviceToken());
        fcmService.pushNotification(notiRequest, cancellationRequest.getBooking().getId());

        NotiRequest notiRequest1 = new NotiRequest();
        notiRequest1.setTitle("Cuộc hẹn với " + customer.getFullname() + " đã bị hủy! Tuy nhiên " + customer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notiRequest1.setBody("Cuộc hẹn với " + customer.getFullname() + " đã bị hủy! Tuy nhiên " + customer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notiRequest1.setToken(photographer.getDeviceToken());
        fcmService.pushNotification(notiRequest1, cancellationRequest.getBooking().getId());

        Notification notification1 = new Notification();
        notification1.setReceiverId(photographer.getId());
        notification1.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification1.setTitle("Cuộc hẹn với " + customer.getFullname() + " đã bị hủy! Tuy nhiên " + customer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notification1.setContent("Cuộc hẹn với " + customer.getFullname() + " đã bị hủy! Tuy nhiên " + customer.getFullname() +" đã bị cảnh cáo sau khi hủy hẹn không hợp lý với bạn, rất mong bạn thông cảm!");
        notification1.setBookingId(cancellationRequest.getBooking().getId());
        notificationRepository.save(notification1);
    }

    public void warnCustomer(CancellationRequest cancellationRequest) {
        Notification notification = new Notification();
        notification.setReceiverId(cancellationRequest.getBooking().getCustomer().getId());
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setTitle("Cảnh báo! Đơn hủy hẹn của bạn với "+  cancellationRequest.getBooking().getPhotographer().getFullname() + " là không hợp lý, nếu tiếp tục có những hành vi hủy hẹn tương tự có thể dẫn tới tài khoản bị vô hiệu hóa");
        notification.setContent("Cảnh báo! Đơn hủy hẹn của bạn với "+  cancellationRequest.getBooking().getPhotographer().getFullname() + " là không hợp lý, nếu tiếp tục có những hành vi hủy hẹn tương tự có thể dẫn tới tài khoản bị vô hiệu hóa");
        notification.setBookingId(cancellationRequest.getBooking().getId());
        notificationRepository.save(notification);
    }

    public void warnPhotographer(CancellationRequest cancellationRequest) {
        Notification notification = new Notification();
        notification.setReceiverId(cancellationRequest.getBooking().getPhotographer().getId());
        notification.setNotificationType(ENotificationType.BOOKING_STATUS);
        notification.setTitle("Cảnh báo! Đơn hủy hẹn của bạn với "+  cancellationRequest.getBooking().getCustomer().getFullname() + " là không hợp lý, nếu tiếp tục có những hành vi hủy hẹn tương tự có thể dẫn tới tài khoản bị vô hiệu hóa");
        notification.setContent("Cảnh báo! Đơn hủy hẹn của bạn với "+  cancellationRequest.getBooking().getCustomer().getFullname() + " là không hợp lý, nếu tiếp tục có những hành vi hủy hẹn tương tự có thể dẫn tới tài khoản bị vô hiệu hóa");
        notification.setBookingId(cancellationRequest.getBooking().getId());
        notificationRepository.save(notification);
    }

    private void mailCustomer(CancellationRequest cancellationRequest) {
        String recipient = cancellationRequest.getBooking().getCustomer().getEmail();
        String sender = "tranthienthao2710@gmail.com";
        String host = "localhost";

        Properties properties = System.getProperties();
        properties.setProperty("mail.smtp.host", host);

        Session session = Session.getDefaultInstance(properties);

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(sender));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
            message.setSubject("PBS - Cảnh báo");
            message.setText("Cảnh báo! Đơn hủy hẹn của bạn với "+  cancellationRequest.getBooking().getCustomer().getFullname() + " là không hợp lý, nếu tiếp tục có những hành vi hủy hẹn tương tự có thể dẫn tới tài khoản bị vô hiệu hóa");

            Transport.send(message);

        } catch (AddressException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    private void mailPhotographer(CancellationRequest cancellationRequest) {
        String recipient = cancellationRequest.getBooking().getPhotographer().getEmail();
        String sender = "tranthienthao2710@gmail.com";
        String host = "localhost";

        Properties properties = System.getProperties();
        properties.setProperty("mail.smtp.host", host);

        Session session = Session.getDefaultInstance(properties);

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(sender));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
            message.setSubject("PBS - Cảnh báo");
            message.setText("Cảnh báo! Đơn hủy hẹn của bạn với "+  cancellationRequest.getBooking().getPhotographer().getFullname() + " là không hợp lý, nếu tiếp tục có những hành vi hủy hẹn tương tự có thể dẫn tới tài khoản bị vô hiệu hóa");

            Transport.send(message);

        } catch (AddressException e) {
            e.printStackTrace();
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}

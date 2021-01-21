package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.NotiRequest;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.Period;
import java.util.Date;
import java.util.List;

@Service
public class CronJobService {

    private BookingService bookingService;
    private BookingRepository bookingRepository;
    private FCMService fcmService;

    @Autowired
    public CronJobService(BookingService bookingService, BookingRepository bookingRepository, FCMService fcmService) {
        this.bookingService = bookingService;
        this.bookingRepository = bookingRepository;
        this.fcmService = fcmService;
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

    @Scheduled(cron = "${app.batch.cron.booking_remind_cron}")
    public void sendBookingRemind() {
        System.out.println("This is booking remind cron job, start at 7am and 9pm on everyday.");
    }

    @Scheduled(cron = "${app.batch.cron.booking_pending_cron}")
    public void checkPendingBookingHourly() {
        System.out.println("This is booking pending checker cron job, start at every hour");
    }
}

package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.WarningEmailContext;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {

    private final ReportRepository reportRepository;
    private final EmailService emailService;
    private final BookingRepository bookingRepository;

    @Autowired
    public ReportService(ReportRepository reportRepository, EmailService emailService, BookingRepository bookingRepository) {
        this.reportRepository = reportRepository;
        this.emailService = emailService;
        this.bookingRepository = bookingRepository;
    }

    public List<Report> getAll() {
        return reportRepository.findAll();
    }

    public Report findById(Long id) {
        return reportRepository.findById(id).get();
    }

    public Report save(Report report) {
        return reportRepository.save(report);
    }

    public Page<Report> getAll(Pageable pageable) {
        return reportRepository.findAllOrderByReportedDate(pageable);
    }

    public void seen(Long id) {
        reportRepository.seen(id);
    }

    public void warn(Long id) {
        Report report = reportRepository.findById(id).get();
        report.setIsSolve(true);
        reportRepository.save(report);
        Booking booking = bookingRepository.findById(report.getBooking().getId()).get();
        booking.setPreviousStatus(booking.getBookingStatus());
        booking.setBookingStatus(EBookingStatus.CANCELLED_ADMIN);
        bookingRepository.save(booking);
        User reported = null;
        if(report.getReporter().getRole().getRole() == ERole.ROLE_CUSTOMER) {
            reported = report.getBooking().getPhotographer();
        } else {
            reported = report.getBooking().getCustomer();
        }
        try {
            WarningEmailContext emailContext = new WarningEmailContext();
            emailContext.init(reported);
            emailContext.buildEmailContent(reported.getFullname());
            emailService.sendMail(emailContext);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
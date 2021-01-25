package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.WarningEmailContext;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
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

    private Page<Report> getAllNotSolve(Pageable pageable) {
        return reportRepository.findAllByIsSolveFalse(pageable);
    }

    private Page<Report> getAllSolve(Pageable pageable) {
        return reportRepository.findAllByIsSolveTrue(pageable);
    }

    private Page<Report> getByDateNotSolve(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return reportRepository.findAllByDateNotSolve(from, to, pageable);
    }

    private Page<Report> getByDateSolve(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return reportRepository.findAllByDateSolve(from, to, pageable);
    }

    private Page<Report> getAllByDate(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return reportRepository.findAllByDate(from, to, pageable);
    }

    public Page<Report> getReports(Pageable pageable, String start, String end, String filter) {
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
                    return reportRepository.findAllOrderByReportedDate(pageable);
                }
                return getAllByDate(pageable, start, end);
            default:
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllNotSolve(pageable);
                }
                return getByDateNotSolve(pageable, start, end);
        }
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
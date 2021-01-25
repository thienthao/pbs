package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.BookingComment;
import fpt.university.pbswebapi.entity.Report;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@Service
public class RatingService {

    private CommentRepository commentRepository;

    @Autowired
    public RatingService(CommentRepository commentRepository) {
        this.commentRepository = commentRepository;
    }

    public Page<BookingComment> getAll(Pageable pageable) {
        return commentRepository.findCommentOrderByCommentedAt(pageable);
    }

    private Page<BookingComment> getAllOne(Pageable pageable) {
        return commentRepository.findAllOne(pageable);
    }

    private Page<BookingComment> getAllTwo(Pageable pageable) {
        return commentRepository.findAllTwo(pageable);
    }

    private Page<BookingComment> getAllThree(Pageable pageable) {
        return commentRepository.findAllThree(pageable);
    }

    private Page<BookingComment> getAllFour(Pageable pageable) {
        return commentRepository.findAllFour(pageable);
    }

    private Page<BookingComment> getAllFive(Pageable pageable) {
        return commentRepository.findAllFive(pageable);
    }

    private Page<BookingComment> getByDateOne(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return commentRepository.findAllOneByDate(from, to, pageable);
    }

    private Page<BookingComment> getByDateTwo(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return commentRepository.findAllTwoByDate(from, to, pageable);
    }

    private Page<BookingComment> getByDateThree(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return commentRepository.findAllThreeByDate(from, to, pageable);
    }

    private Page<BookingComment> getByDateFour(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return commentRepository.findAllFourByDate(from, to, pageable);
    }

    private Page<BookingComment> getByDateFive(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return commentRepository.findAllFiveByDate(from, to, pageable);
    }

    private Page<BookingComment> getByDateAll(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return commentRepository.findByDateAll(from, to, pageable);
    }

    public Page<BookingComment> getRatings(Pageable pageable, String start, String end, String filter) {
        switch (filter) {
            case "one":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllOne(pageable);
                }
                return getByDateOne(pageable, start, end);
            case "two":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllTwo(pageable);
                }
                return getByDateTwo(pageable, start, end);
            case "three":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllThree(pageable);
                }
                return getByDateThree(pageable, start, end);
            case "four":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllFour(pageable);
                }
                return getByDateFour(pageable, start, end);
            case "five":
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAllFive(pageable);
                }
                return getByDateFive(pageable, start, end);
            default:
                if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
                    return getAll(pageable);
                }
                return getByDateAll(pageable, start, end);
        }
    }
}

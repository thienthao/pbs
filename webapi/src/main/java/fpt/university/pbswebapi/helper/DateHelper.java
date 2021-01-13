package fpt.university.pbswebapi.helper;

import fpt.university.pbswebapi.entity.DayOfWeek;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class DateHelper {

    public static LocalTime getTimeFromLocalDateTime(LocalDateTime localDateTime) {
        return localDateTime.toLocalTime();
    }

    private List<LocalTime> getHoursBetweenTwoTime(LocalTime from, LocalTime to) {
        int hourFrom = from.getHour();
        int hourTo = to.getHour();
        List<LocalTime> results = new ArrayList<>();
        results.add(LocalTime.of(hourFrom, 0));
        while(hourFrom != hourTo) {
            hourFrom += 1;
            results.add(LocalTime.of(hourFrom, 0));
        }
        return results;
    }

    public static LocalDateTime convertToLocalDateTimeViaString(String datetime) {
        DateTimeFormatter localDateTimeFormmater = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return LocalDateTime.parse(datetime, localDateTimeFormmater);
    }

    public static Date convertToDateViaString(String datetime) {
        DateTimeFormatter localDateTimeFormmater = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localDateTime = LocalDateTime.parse(datetime, localDateTimeFormmater);
        return DateHelper.convertToDateViaInstant(localDateTime);
    }

    public static Date convertToDateViaInstant(LocalDate dateToConvert) {
        return java.util.Date.from(dateToConvert.atStartOfDay()
                .atZone(ZoneId.of("Asia/Ho_Chi_Minh"))
                .toInstant());
    }

    public static Date convertToDateViaInstant(LocalDateTime dateToConvert) {
        return java.util.Date
                .from(dateToConvert.atZone(ZoneId.of("Asia/Ho_Chi_Minh"))
                        .toInstant());
    }

    public static LocalDateTime convertToLocalDateTimeViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime();
    }

    public static LocalDate convertToLocalDateViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
    }

    public static LocalTime plusHour(LocalTime localTime, long hour) {
        return localTime.plusHours(hour);
    }

    public static List<LocalDate> getDatesBetween(
            LocalDate startDate, LocalDate endDate) {

        long numOfDaysBetween = ChronoUnit.DAYS.between(startDate, endDate);
        return IntStream.iterate(0, i -> i + 1)
                .limit(numOfDaysBetween)
                .mapToObj(i -> startDate.plusDays(i))
                .collect(Collectors.toList());
    }

    public static List<LocalDate> getDatesBetweenUsingJava9(
            LocalDate startDate, LocalDate endDate) {

        return startDate.datesUntil(endDate)
                .collect(Collectors.toList());
    }

    public static boolean isDateDayOfWeek(LocalDate date, java.time.DayOfWeek dow) {
        return date.getDayOfWeek() == dow;
    }

    public static java.time.DayOfWeek getNotWorkingDay(DayOfWeek dow) {
        switch (dow.getDay()) {
            case 1:
                return java.time.DayOfWeek.SUNDAY;
            case 2:
                return java.time.DayOfWeek.MONDAY;
            case 3:
                return java.time.DayOfWeek.TUESDAY;
            case 4:
                return java.time.DayOfWeek.WEDNESDAY;
            case 5:
                return java.time.DayOfWeek.THURSDAY;
            case 6:
                return java.time.DayOfWeek.FRIDAY;
            case 7:
                return java.time.DayOfWeek.SATURDAY;
        }

        //dead code
        return java.time.DayOfWeek.SUNDAY;
    }
}

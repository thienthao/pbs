package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.BusyDay;
import fpt.university.pbswebapi.entity.DayOfWeek;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Calendar {

    private List<Date> bookingDates;

    private List<Date> busyDays;
}

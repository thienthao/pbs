package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.BusyDay;
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

    private List<BookingDate> bookingDates;

    private List<BusyDay> busyDays;
}

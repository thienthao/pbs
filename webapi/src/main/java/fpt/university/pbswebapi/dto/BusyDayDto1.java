package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.Booking;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BusyDayDto1 {

    private List<Date> busyDays;

    private Map<Date, Booking> bookedDays;
}

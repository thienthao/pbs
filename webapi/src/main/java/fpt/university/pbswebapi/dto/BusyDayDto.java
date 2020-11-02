package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BusyDayDto {

    private List<Date> busyDays;

    private List<Date> bookedDays;
}

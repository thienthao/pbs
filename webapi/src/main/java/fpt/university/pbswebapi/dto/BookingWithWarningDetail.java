package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.Booking;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookingWithWarningDetail {

    private Booking booking;

    private List<String> timeWarnings;

    private List<String> distanceWarning;

    private List<WeatherNoti> weatherWarning;

    private List<String> selfWarnDistance;
}

package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Date;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WeatherInfoWithTime {

    private Boolean isHourly;

    private LocalDate date;

    private String location;

    private Boolean overall;

    private Map<LocalTime, WeatherNoti> time;

}

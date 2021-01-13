package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.Map;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WeatherInfoWithTime {

    private String location;

    private Boolean overall;

    private Map<Date, WeatherNoti> time;

}

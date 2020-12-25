package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class WeatherNoti {

    private String noti;

    private String outlook;

    private Double temperature;

    private Double humidity;

    private Double windSpeed;

}

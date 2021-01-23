package fpt.university.pbswebapi.helper.weather;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ClimaHourly {

    @JsonProperty("temp")
    private Object temp;

    @JsonProperty("humidity")
    private Object humidity;

    @JsonProperty("wind_speed")
    private Object windSpeed;

    @JsonProperty("weather_code")
    private Object code;

    public ClimaHourly() {
    }

    public ClimaHourly(Object temp, Object humidity, Object windSpeed, Object code) {
        this.temp = temp;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
        this.code = code;
    }

    public Object getTemp() {
        return temp;
    }

    public void setTemp(Object temp) {
        this.temp = temp;
    }

    public Object getHumidity() {
        return humidity;
    }

    public void setHumidity(Object humidity) {
        this.humidity = humidity;
    }

    public Object getWindSpeed() {
        return windSpeed;
    }

    public void setWindSpeed(Object windSpeed) {
        this.windSpeed = windSpeed;
    }

    public Object getCode() {
        return code;
    }

    public void setCode(Object code) {
        this.code = code;
    }
}

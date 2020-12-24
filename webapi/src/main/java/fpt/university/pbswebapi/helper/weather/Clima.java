package fpt.university.pbswebapi.helper.weather;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Clima {

    @JsonProperty("temp")
    private List<Object> temp;

    @JsonProperty("humidity")
    private List<Object> humidity;

    @JsonProperty("wind_speed")
    private List<Object> windSpeed;

    @JsonProperty("weather_code")
    private Object code;

    @JsonProperty("observation_time")
    private Object observation;

    public Clima() {
    }

    public Clima(List<Object> temp, List<Object> humidity, List<Object> windSpeed, Object code, Object observation) {
        this.temp = temp;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
        this.code = code;
        this.observation = observation;
    }

    @Override
    public String toString() {
        return "Clima{" +
                "temp=" + temp +
                ", humidity=" + humidity +
                ", windSpeed=" + windSpeed +
                ", code=" + code +
                ", observation=" + observation +
                '}';
    }

    public List<Object> getTemp() {
        return temp;
    }

    public void setTemp(List<Object> temp) {
        this.temp = temp;
    }

    public List<Object> getHumidity() {
        return humidity;
    }

    public void setHumidity(List<Object> humidity) {
        this.humidity = humidity;
    }

    public List<Object> getWindSpeed() {
        return windSpeed;
    }

    public void setWindSpeed(List<Object> windSpeed) {
        this.windSpeed = windSpeed;
    }

    public Object getCode() {
        return code;
    }

    public void setCode(Object code) {
        this.code = code;
    }

    public Object getObservation() {
        return observation;
    }

    public void setObservation(Object observation) {
        this.observation = observation;
    }

}

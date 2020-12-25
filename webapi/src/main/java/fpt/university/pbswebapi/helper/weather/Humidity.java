package fpt.university.pbswebapi.helper.weather;

public class Humidity {

    private Double min;

    private Double max;

    @Override
    public String toString() {
        return "Humidity{" +
                "min=" + min +
                ", max=" + max +
                '}';
    }

    public Humidity(Double min, Double max) {
        this.min = min;
        this.max = max;
    }

    public Humidity() {
    }

    public Double getMin() {
        return min;
    }

    public void setMin(Double min) {
        this.min = min;
    }

    public Double getMax() {
        return max;
    }

    public void setMax(Double max) {
        this.max = max;
    }
}

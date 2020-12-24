package fpt.university.pbswebapi.helper.weather;

public class WindSpeed {

    private Double min;

    private Double max;

    @Override
    public String toString() {
        return "WindSpeed{" +
                "min=" + min +
                ", max=" + max +
                '}';
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

    public WindSpeed() {
    }

    public WindSpeed(Double min, Double max) {
        this.min = min;
        this.max = max;
    }
}

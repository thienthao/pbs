package fpt.university.pbswebapi.helper.weather;

public class Temp {

    private Double min;

    private Double max;

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

    public Temp() {
    }

    public Temp(Double min, Double max) {
        this.min = min;
        this.max = max;
    }

    @Override
    public String toString() {
        return "Temp{" +
                "min=" + min +
                ", max=" + max +
                '}';
    }
}

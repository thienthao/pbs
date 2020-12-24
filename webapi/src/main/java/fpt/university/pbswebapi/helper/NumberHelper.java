package fpt.university.pbswebapi.helper;

import java.text.DecimalFormat;

public class NumberHelper {

    private static DecimalFormat df = new DecimalFormat("#.#");

    public static Double format(Double input) {
        Double result = 0.0;
        try {
            result = Double.parseDouble(df.format(input));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static Float format(Float input) {
        Float result = Float.parseFloat("0.0");
        try {
            result = Float.parseFloat(df.format(input));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}

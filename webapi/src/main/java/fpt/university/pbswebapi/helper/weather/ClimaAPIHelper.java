package fpt.university.pbswebapi.helper.weather;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;
import java.util.Map;

public class ClimaAPIHelper {

    public static Temp mapTemp(List<Object> temp) {
        Temp result = new Temp();
        for(Object obj : temp) {
            Double minValue = getMin(obj);
            Double maxValue = getMax(obj);
            if(minValue != 0.0) {
                result.setMin(minValue);
            }
            if(maxValue != 0.0) {
                result.setMax(maxValue);
            }
        }
        return result;
    }

    public static Humidity mapHumidity(List<Object> humidity) {
        Humidity result = new Humidity();
        for(Object obj : humidity) {
            Double minValue = getMin(obj);
            Double maxValue = getMax(obj);
            if(minValue != 0.0) {
                result.setMin(minValue);
            }
            if(maxValue != 0.0) {
                result.setMax(maxValue);
            }
        }
        return result;
    }

    public static WindSpeed mapWindSpeed(List<Object> windSpeed) {
        WindSpeed result = new WindSpeed();
        for(Object obj : windSpeed) {
            Double minValue = getMin(obj);
            Double maxValue = getMax(obj);
            if(minValue != 0.0) {
                result.setMin(minValue);
            }
            if(maxValue != 0.0) {
                result.setMax(maxValue);
            }
        }
        return result;
    }

    public static String mapOutlook(Object obj) {
        String result = "";
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(obj, Map.class);
            String code = map.get("value").toString();
            if(code.contains("freezing")) {
                return "freezing";
            } else if (code.contains("ice")) {
                return "ice";
            } else if (code.contains("rain")) {
                return "rainy";
            } else if (code.contains("cloudy")) {
                return "cloudy";
            } else if (code.contains("clear")) {
                return "clear";
            } else {
                return "sunny";
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return result;
    }

    public static Double getMin(Object obj) {
        Double result = 0.0;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(obj, Map.class);
            Object min = map.get("min");
            if(min != null) {
                Map<String, Object> minmap = objectMapper.convertValue(min, Map.class);
                result = Double.parseDouble(minmap.get("value").toString());
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return result;
    }

    public static Double getMax(Object obj) {
        Double result = 0.0;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(obj, Map.class);
            Object max = map.get("max");
            if(max != null) {
                Map<String, Object> maxmap = objectMapper.convertValue(max, Map.class);
                result = Double.parseDouble(maxmap.get("value").toString());
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return result;
    }

    public static String mapDate(Object obj) {
        String result = "";
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(obj, Map.class);
//            Map<String, Object> valuemap = objectMapper.convertValue(map.get("value"), Map.class);
            result = map.get("value").toString();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return result;
    }

    public static String getTemp(Temp temp) {
        Double value = (temp.getMax() + temp.getMin()) / (double) 2;
        if(value > 27) {
            return "hot";
        } else if (value <= 27 && value >= 22) {
            return "mild";
        } else if (value <= 22 && value >= 16){
            return "cool";
        } else {
            return "cold";
        }
    }

    public static Double getTempDouble(Temp temp) {
        return (temp.getMax() + temp.getMin()) / (double) 2;
    }

    public static String getHumidity(Humidity humidity) {
        Double value = (humidity.getMax() + humidity.getMin()) / (double) 2;
        if(value > 60) {
            return "high";
        } else if (value >= 40 && value <= 60){
            return "normal";
        } else {
            return "low";
        }
    }

    public static Double getHumidityDouble(Humidity humidity) {
        return (humidity.getMax() + humidity.getMin()) / (double) 2;
    }

    public static String getWindSpeed(WindSpeed windSpeed) {
        Double value = (windSpeed.getMax() + windSpeed.getMin()) / (double) 2;
        if(value > 10.6) {
            return "strong";
        } else if (value <= 10.6 && value >= 5.3){
            return "fresh";
        } else if (value >= 0 && value <= 5.3) {
            return "gentle";
        } else {
            return "zero";
        }
    }

    public static Double getWindSpeedDouble(WindSpeed windSpeed) {
        return (windSpeed.getMax() + windSpeed.getMin()) / (double) 2;
    }
}

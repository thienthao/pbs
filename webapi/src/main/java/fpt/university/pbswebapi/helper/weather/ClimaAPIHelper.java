package fpt.university.pbswebapi.helper.weather;

import com.fasterxml.jackson.databind.ObjectMapper;
import fpt.university.pbswebapi.dto.WeatherNoti;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.helper.WeatherBayesian;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.text.MessageFormat;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ClimaAPIHelper {
    
    private static final String APIKEY1 = "LNwNBINAJLxv3FDkDpFKJ6Nen1cBRvpL";
    private static final String APIKEY2 = "LNi5rDEQAC5YoagsDYJJckE2g2eLfUgp";
    private static final String APIKEY3 = "nDVs44XgBuVQLHARVgHnB1JCmJQuRp8E";

    public static Double mapTempHourly(Object temp) {
        Double result = 0.0;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(temp, Map.class);
            result = Double.parseDouble(map.get("value").toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static Double mapHumidityHourly(Object humidity) {
        Double result = 0.0;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(humidity, Map.class);
            result = Double.parseDouble(map.get("value").toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static Double mapWindSpeedHourly(Object windSpeed) {
        Double result = 0.0;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(windSpeed, Map.class);
            result = Double.parseDouble(map.get("value").toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static String mapWeatherCodeHourly(Object weatherCode) {
        String result = "";
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Map<String, Object> map = objectMapper.convertValue(weatherCode, Map.class);
            result = map.get("value").toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

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

    public static String getTempHourly(Double value) {
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

    public static String getHumidityHourly(Double value) {
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

    public static String getWindSpeedHourly(Double value) {
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

    public static WeatherNoti getWeatherNoti(HttpResponse<String> weatherResponse, LocalDate date) {
        WeatherNoti result = null;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            Clima[] climas = objectMapper.readValue(weatherResponse.body(), Clima[].class);

            String outlook = "";
            String temperature = "";
            String humid = "";
            String wind = "";
            WeatherBayesian ba = new WeatherBayesian();
            ba.readTable();

            for(int i = 0; i < climas.length; i++) {
//                mapTemp(climas[i].getTemp());
                Clima clima = climas[i];
                if(ClimaAPIHelper.mapDate(clima.getObservation()).equalsIgnoreCase(date.toString())) {
                    Temp temp = ClimaAPIHelper.mapTemp(clima.getTemp());
                    Humidity humidity = ClimaAPIHelper.mapHumidity(clima.getHumidity());
                    WindSpeed windSpeed = ClimaAPIHelper.mapWindSpeed(clima.getWindSpeed());
                    temperature = ClimaAPIHelper.getTemp(temp);
                    humid = ClimaAPIHelper.getHumidity(humidity);
                    wind = ClimaAPIHelper.getWindSpeed(windSpeed);
                    outlook = ClimaAPIHelper.mapOutlook(clima.getCode());

                    Boolean isSuitable = ba.comparedV2(outlook, temperature, humid, wind);
                    if(isSuitable != null) {
                        result = new WeatherNoti();
                        result.setIsSuitable(isSuitable);
                        result.setOutlook(outlook);
                        result.setTemperature(ClimaAPIHelper.getTempDouble(temp));
                        result.setHumidity(ClimaAPIHelper.getHumidityDouble(humidity));
                        result.setWindSpeed(ClimaAPIHelper.getWindSpeedDouble(windSpeed));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static WeatherNoti getWeatherNotiHourly(HttpResponse<String> weatherResponse) {
        WeatherNoti result = null;
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            ClimaHourly[] climaHourlys = objectMapper.readValue(weatherResponse.body(), ClimaHourly[].class);
            ClimaHourly climaHourly = climaHourlys[0];

            String outlook = "";
            String temperature = "";
            String humid = "";
            String wind = "";
            WeatherBayesian ba = new WeatherBayesian();

            Double temp = ClimaAPIHelper.mapTempHourly(climaHourly.getTemp());
            Double humidity = ClimaAPIHelper.mapHumidityHourly(climaHourly.getHumidity());
            Double windSpeed = ClimaAPIHelper.mapWindSpeedHourly(climaHourly.getWindSpeed());
            temperature = ClimaAPIHelper.getTempHourly(temp);
            humid = ClimaAPIHelper.getHumidityHourly(humidity);
            wind = ClimaAPIHelper.getWindSpeedHourly(windSpeed);
            outlook = ClimaAPIHelper.mapOutlook(climaHourly.getCode());

            Boolean isSuitable = ba.comparedV2(outlook, temperature, humid, wind);
            if(isSuitable != null) {
                result = new WeatherNoti();
                result.setIsSuitable(isSuitable);
                result.setOutlook(outlook);
                result.setTemperature(temp);
                result.setHumidity(humidity);
                result.setWindSpeed(windSpeed);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static HttpResponse<String> getWeatherResponseAtTime(Double lat, Double lon, String date, String time) {
        HttpResponse<String> response = null;
        try {
            HttpClient httpClient = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_2)
                    .build();
            String url = MessageFormat.format("https://api.climacell.co/v3/weather/forecast/hourly?" +
                    "lat={0}&lon={1}" +
                    "&fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si" +
                    "&start_time={2}T{3}Z&end_time={2}T{3}Z" +
                    "&apikey={4}",
                    lat, lon, date, time, APIKEY1);
            HttpRequest request = HttpRequest.newBuilder()
                    .GET()
                    .uri(URI.create(url))
                    .build();

            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if(response.statusCode() != 200) {
                url = MessageFormat.format("https://api.climacell.co/v3/weather/forecast/hourly?" +
                                "lat={0}&lon={1}" +
                                "&fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si" +
                                "&start_time={2}T{3}Z&end_time={2}T{3}Z" +
                                "&apikey={4}",
                        lat, lon, date, time, APIKEY2);
                request = HttpRequest.newBuilder()
                        .GET()
                        .uri(URI.create(url))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

                if (response.statusCode() != 200) {
                    url = MessageFormat.format("https://api.climacell.co/v3/weather/forecast/hourly?" +
                                    "lat={0}&lon={1}" +
                                    "&fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si" +
                                    "&start_time={2}T{3}Z&end_time={2}T{3}Z" +
                                    "&apikey={4}",
                            lat, lon, date, time, APIKEY3);
                    request = HttpRequest.newBuilder()
                            .GET()
                            .uri(URI.create(url))
                            .build();

                    response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                HttpClient httpClient = HttpClient.newBuilder()
                        .version(HttpClient.Version.HTTP_2)
                        .build();
                String url = MessageFormat.format("https://api.climacell.co/v3/weather/forecast/hourly?" +
                                "lat={0}&lon={1}" +
                                "&fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si" +
                                "&start_time={2}T{3}Z&end_time={2}T{3}Z" +
                                "&apikey={4}",
                        lat, lon, date, time, APIKEY3);
                HttpRequest request = HttpRequest.newBuilder()
                        .GET()
                        .uri(URI.create(url))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return response;
    }

    public static HttpResponse<String> getWeatherResponse(Double lat, Double lon, String date) {
        HttpResponse<String> response = null;
        try {
            HttpClient httpClient = HttpClient.newBuilder()
                    .version(HttpClient.Version.HTTP_2)
                    .build();
            String url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                    "lat=" + lat + "&lon=" + lon + "&" +
                    "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                    "start_time="+ date +"T09:00:00&apikey=" + APIKEY1;
            HttpRequest request = HttpRequest.newBuilder()
                    .GET()
                    .uri(URI.create(url))
                    .build();

            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if(response.statusCode() != 200) {
                url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                        "lat=" + lat + "&lon=" + lon + "&" +
                        "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                        "start_time="+ date +"T09:00:00&apikey=" + APIKEY2;
                request = HttpRequest.newBuilder()
                        .GET()
                        .uri(URI.create(url))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

                if (response.statusCode() != 200) {
                    url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                            "lat=" + lat + "&lon=" + lon + "&" +
                            "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                            "start_time="+ date +"T09:00:00&apikey=" + APIKEY3;
                    request = HttpRequest.newBuilder()
                            .GET()
                            .uri(URI.create(url))
                            .build();

                    response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
                }
            }
        } catch (Exception e) {
            System.out.println(e);
            try {
                HttpClient httpClient = HttpClient.newBuilder()
                        .version(HttpClient.Version.HTTP_2)
                        .build();
                String url = "https://api.climacell.co/v3/weather/forecast/daily?" +
                        "lat=" + lat + "&lon=" + lon + "&" +
                        "fields=temp%2Chumidity%2Cwind_speed%2Cweather_code&unit_system=si&" +
                        "start_time="+ date +"T09:00:00&apikey=" + APIKEY3;
                HttpRequest request = HttpRequest.newBuilder()
                        .GET()
                        .uri(URI.create(url))
                        .build();

                response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return response;
    }
}

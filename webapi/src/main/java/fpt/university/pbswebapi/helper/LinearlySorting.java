package fpt.university.pbswebapi.helper;

import fpt.university.pbswebapi.entity.Location;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.repository.CustomRepository;
import fpt.university.pbswebapi.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

import static java.util.Collections.reverseOrder;

@Component
public class LinearlySorting {

    private CustomRepository customRepository;

    private LocationRepository locationRepository;

    @Autowired
    public LinearlySorting(CustomRepository customRepository, LocationRepository locationRepository) {
        this.customRepository = customRepository;
        this.locationRepository = locationRepository;
    }

    public List<User> sortLinearly(List<User> unsorted, double lat, double lon) {
        Map<User, Float> result = toUserMap(unsorted, lat, lon);
        result = sortByValue(result);
        return new ArrayList<>(result.keySet());
    }

    private Map<User, Float> toUserMap(List<User> unsorted, double lat, double lon) {
        Map<User, Float> result = new HashMap<>();
        float sumPrice =  customRepository.getSumPrice();
        float sumDistance = customRepository.getSumDistance(lat, lon);
        for (int i = 0; i < unsorted.size(); i++) {
            User photographer = unsorted.get(i);

            // cal rating
            float rating = (float) (photographer.getRatingCount() / 5.0);

            // cal price
            float priceRatio = (float) (photographer.getAveragePackagePrice() / sumPrice);
            float price = (float) (1.0 - priceRatio);

            // cal distance
            float distanceRatio = (float) (photographer.getDistance() / sumDistance);
            float distance = (float) 1.0 - distanceRatio;

            float score = (float) (((0.3) * rating) + ((0.4) * price) + ((0.3) * distance));

            result.put(photographer, score);
        }
        return  result;
    }

    public static <K, V extends Comparable<? super V>> Map<K, V> sortByValue(Map<K, V> map) {
        List<Map.Entry<K, V>> list = new ArrayList<>(map.entrySet());
        list.sort(reverseOrder(Map.Entry.comparingByValue()));

        Map<K, V> result = new LinkedHashMap<>();
        for (Map.Entry<K, V> entry : list) {
            result.put(entry.getKey(), entry.getValue());
        }

        return result;
    }

}

package fpt.university.pbswebapi.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import fpt.university.pbswebapi.bucket.BucketName;
import fpt.university.pbswebapi.dto.Calendar;
import fpt.university.pbswebapi.dto.*;
import fpt.university.pbswebapi.entity.*;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.filesstore.FileStore;
import fpt.university.pbswebapi.helper.*;
import fpt.university.pbswebapi.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.Month;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static java.util.Collections.reverseOrder;
import static org.apache.http.entity.ContentType.*;

@Service
public class PhotographerService {
    private final UserRepository phtrRepo;
    private final FileStore fileStore;
    private final BusyDayRepository busyDayRepository;
    private final BookingRepository bookingRepository;
    private final LocationRepository locationRepository;
    private final ServicePackageRepository packageRepository;
    private final WorkingDayRepository workingDayRepository;
    private final CommentRepository commentRepository;
    private final LinearlySorting linearlySorting;
    private final CustomRepository customRepository;
    private final HttpClient httpClient = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_2)
            .build();

    @Autowired
    public PhotographerService(UserRepository phtrRepo, FileStore fileStore, BusyDayRepository busyDayRepository, BookingRepository bookingRepository, LocationRepository locationRepository, ServicePackageRepository packageRepository, WorkingDayRepository workingDayRepository, CommentRepository commentRepository, LinearlySorting linearlySorting, CustomRepository customRepository) {
        this.phtrRepo = phtrRepo;
        this.fileStore = fileStore;
        this.busyDayRepository = busyDayRepository;
        this.bookingRepository = bookingRepository;
        this.locationRepository = locationRepository;
        this.packageRepository = packageRepository;
        this.workingDayRepository = workingDayRepository;
        this.commentRepository = commentRepository;
        this.linearlySorting = linearlySorting;
        this.customRepository = customRepository;
    }

    public List<User> findAllPhotographers() {
        return phtrRepo.findAllPhotographer(Long.parseLong("2"));
    }

    public List<User> findAllCustomers() {
        return phtrRepo.findAllCustomers(Long.parseLong("1"));
    }


    public String uploadAvatar(String id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "avatar");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(Long.parseLong(id));
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setAvatar("http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/download");
                phtrRepo.save(photographer);
                return "http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public byte[] downloadAvatar(String id) {
        String path = String.format("%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                id);
        return fileStore.download(path, id + "-avatar");
    }

    public SplitedPhotographerDto findOne(Long id) {
        Optional<User> photographer = phtrRepo.findById(id);
        if(photographer.isPresent()) {
            SplitedPhotographerDto result = DtoMapper.toSplitedPhotographerDto(photographer.get());
            Integer booked = bookingRepository.countBooking(result.getId());
            Double ratingCount = customRepository.getRatingCount(result.getId());
            result.setRatingCount(ratingCount);
            result.setBooked(booked);
            return result;
        }
        else {
            throw new BadRequestException("Photographer not exists");
        }
    }

    public Page<User> findPhotographersByRating(Pageable paging, String city) {
        if(city.equalsIgnoreCase("")) {
            return phtrRepo.findPhotographersOrderByRating(paging, Long.parseLong("2"));
        }
        return phtrRepo.findPhotographersInCityOrderByRating(paging, Long.parseLong("2"), city);
    }

    public List<User> findPhotographersByRatingCustom(String city) {
        if(city.equalsIgnoreCase("")) {
            return customRepository.getAllByRating();
        }
        return customRepository.findPhotographersInCityOrderByRating(city);
    }


    public String fakeAvatar(Long id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "avatar");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(id);
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setAvatar("http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/download");
                phtrRepo.save(photographer);
                return "http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public String uploadCover(String id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "cover");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(Long.parseLong(id));
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setCover("http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/cover/download");
                phtrRepo.save(photographer);
                return "http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/cover/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public byte[] downloadCover(String id) {
        String path = String.format("%s/%s",
                BucketName.PROFILE_IMAGE.getBucketName(),
                id);
        return fileStore.download(path, id + "-cover");
    }

    public String fakeCover(Long id, MultipartFile file) {
        // check if file empty
        if(file.isEmpty()) {
            throw new IllegalStateException("Cannot upload empty file [ " + file.getSize() + " ]");
        }

        // check if file not image
        if(!Arrays.asList(IMAGE_JPEG.getMimeType(), IMAGE_PNG.getMimeType(), IMAGE_GIF.getMimeType()).contains(file.getContentType())) {
            throw new IllegalStateException("File must be image [ " + file.getContentType() + " ]");
        }

        // metadata
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));

        // format file name and path
        String path = String.format("%s/%s", BucketName.PROFILE_IMAGE.getBucketName(), id);
        String filename = String.format("%s-%s", id, "cover");

        // Get album to set thumbnail link
        Optional<User> phtrOptional = phtrRepo.findById(id);
        if(phtrOptional.isPresent()) {
            // save photo and save link to repo
            try {
                fileStore.save(path, filename, Optional.of(metadata), file.getInputStream());
                String fullpath = String.format("%s/%s", path, filename);
                User photographer = phtrOptional.get();
                photographer.setCover("http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/cover/download");
                phtrRepo.save(photographer);
                return "http://194.59.165.195:8080/pbs-webapi/api/photographers/" + id + "/cover/download";
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }
        } else {
            return null;
        }
    }

    public List<User> sortByMultipleFactors(double lat, double lon, long category, String city) {
        List<User> result;
        if(category == 1) {
            if(city.equalsIgnoreCase("")) {
                result = customRepository.queryForMultipleFactorSorting(lat, lon);
            } else {
                result = customRepository.queryForMultipleFactorSortingWhereCity(lat, lon, city);
            }
        } else {
            if(city.equalsIgnoreCase("")) {
                result = customRepository.queryForMultipleFactorSortingWhereCategory(lat, lon, category);
            } else {
                result = customRepository.queryForMultipleFactorSortingWhereCategoryAndCity(lat, lon, category, city);
            }
        }
        result = linearlySorting.sortLinearly(result, lat, lon);
        return result;
    }

    public List<User> findPhotographersByFactors(double lat, double lon, long category, String city) {
        List<User> photographers = new ArrayList<>();
        if(category == 1) {
            if(city.equalsIgnoreCase("")) {
                photographers = customRepository.getAllByRating();
            } else {
                photographers = customRepository.findPhotographersInCityOrderByRating(city);
            }
        } else {
            if(city.equalsIgnoreCase("")) {
                photographers = customRepository.findPhotographersByCategorySortByRating(category);
            } else {
                photographers = customRepository.findPhotographersByCategoryAndCitySortByRating(city, category);
            }
        }
        List<User> sorted = new ArrayList<>();
        Map<Long, Float> result = new HashMap<>();
        int sumPrice = 0;
        double sumDistance = 0;

        for(int i = 0; i < photographers.size(); i++) {
            // cal sum distance
            List<Location> locations = locationRepository.findAllByUserId(photographers.get(i).getId());
            // dang fake khoang cach photographer
            double tmpDistance = 100;
            for (Location location : locations) {
                double distance = MapHelper.distance(lat, location.getLatitude(), lon, location.getLongitude());
                if(distance < tmpDistance)
                    tmpDistance = distance;
            }
            sumDistance += tmpDistance;

            // cal sum price
            if(photographers.get(i).getPackages() != null) {
                if(photographers.get(i).getPackages().size() > 0) {
                    if (photographers.get(i).getPackages().get(0).getPrice() != null)
                        sumPrice += photographers.get(i).getPackages().get(0).getPrice();
                }
            }
        }

        for(int i = 0; i < photographers.size(); i++) {
            //cal rating
            float rating = 0;
            if(photographers.get(i).getRatingCount() != null)
                rating = (float) (0.3 * (photographers.get(i).getRatingCount() / 5.0));

            //cal distance
            List<Location> locations = locationRepository.findAllByUserId(photographers.get(i).getId());
            double tmpDistance = 100;
            for (Location location : locations) {
                double distance = MapHelper.distance(lat, location.getLatitude(), lon, location.getLongitude());
                if(distance < tmpDistance)
                    tmpDistance = distance;
            }
            double distanceRatio = tmpDistance / sumDistance;
            double distanceSub = (double) 1.0 - distanceRatio;
            double distance = (double) (0.3 * distanceSub);

            //cal price
            float price = (float) (0 * 0.4);
            float tile = 0;
            float tru = 0;
            if(photographers.get(i).getPackages() != null) {
                if(photographers.get(i).getPackages().size() > 0) {
                    if (photographers.get(i).getPackages().get(0).getPrice() != null)
                        tile =  ((float)photographers.get(i).getPackages().get(0).getPrice() / (float)sumPrice);
                        tru =  (float) 1.0 - tile;
                        price = (float) (0.4 * tru);
                }
            }

            //score
            float score = (float) (rating + price + distance) * 100;
            result.put(photographers.get(i).getId(), score);
        }
        result = sortByValue(result);
        result.forEach((id, score) -> {
            // add to sorted where id = id
            sorted.add(customRepository.findOne(id));
        });
        return sorted;
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

    public BusyDay addBusyDays(Long ptgId, BusyDay busyDay) {
        return busyDayRepository.save(busyDay);
    }

    public List<BusyDay> getBusyDays(Long ptgId, String fromString, String toString) {
        Date from;
        Date to;
        List<BusyDay> results = new ArrayList<>();
        try {
            fromString = fromString + " 00:00";
            toString = toString + " 23:59";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime localFrom = LocalDateTime.parse(fromString, formatter);
            LocalDateTime localTo = LocalDateTime.parse(toString, formatter);
            from = DateHelper.convertToDateViaInstant(localFrom);
            to = DateHelper.convertToDateViaInstant(localTo);
            return busyDayRepository.findByPhotographerIdBetweenStartDateEndDate(ptgId, from, to);
        } catch (Exception e) {
            System.out.println(e);
        }
        return results;
    }

    public List<BusyDay> getBusyDaysSince(Long ptgId, String sinceString) {
        Date since;
        List<BusyDay> results = new ArrayList<>();
        try {
            sinceString = sinceString + " 00:00";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime localSince = LocalDateTime.parse(sinceString, formatter);
            since = DateHelper.convertToDateViaInstant(localSince);
            return busyDayRepository.findByPhotographerIdSinceStartDate(ptgId, since);
        } catch (Exception e) {
            System.out.println(e);
        }
        return results;
    }

    public Page<User> findPhotographersByCategorySortByRating(Pageable paging, long categoryId, String city) {
        if(city.equalsIgnoreCase("")) {
            return phtrRepo.findPhotographersByCategorySortByRating(paging, categoryId);
        }
        return phtrRepo.findPhotographersByCategoryAndCitySortByRating(paging, categoryId, city);
    }

    public List<User> findPhotographersByCategorySortByRatingCustom(long categoryId, String city) {
        if(city.equalsIgnoreCase("")) {
            return customRepository.findPhotographersByCategorySortByRating(categoryId);
        }
        return customRepository.findPhotographersByCategoryAndCitySortByRating(city, categoryId);
    }

    public List<BusyDay> getBusyDays(Long ptgId) {
        return busyDayRepository.findAllByPhotographerId(ptgId);
    }

    public BusyDayDto getUnavailableDays(Long ptgId) {
        List<Date> busyDays = new ArrayList<>();
        List<Date> bookedDays = new ArrayList<>();

        List<BusyDay> busyDaysObj = busyDayRepository.findAllByPhotographerId(ptgId);
        List<Booking> bookings = bookingRepository.findBookingsByPhotographerId(ptgId);
        for (BusyDay busyDay : busyDaysObj) {
            busyDays.add(busyDay.getStartDate());
        }
        for (Booking booking : bookings) {
            bookedDays.add(booking.getStartDate());
        }
        return new BusyDayDto(busyDays, bookedDays);
    }

    public BusyDayDto1 getSchedule(Long ptgId) {
        List<Date> busyDays = new ArrayList<>();;

        Map<Date, Booking> bookedDays = new HashMap<>();

        List<BusyDay> busyDaysObj = busyDayRepository.findAllByPhotographerId(ptgId);
        List<Booking> bookings = bookingRepository.findBookingsByPhotographerId(ptgId);
        for (BusyDay busyDay : busyDaysObj) {
            busyDays.add(busyDay.getStartDate());
        }
        for (Booking booking : bookings) {
            bookedDays.put(booking.getStartDate(), booking);
        }
        return new BusyDayDto1(busyDays, bookedDays);
    }

    public PhotographerInfoDto editInfo(PhotographerInfoDto photographerDto) {
        User photographer = phtrRepo.findById(photographerDto.getId()).get();
        photographer.setDescription(photographerDto.getDescription());
        photographer.setEmail(photographerDto.getEmail());
        photographer.setFullname(photographerDto.getFullname());
        photographer.setPhone(photographerDto.getPhone());
        photographer.setLocations(DtoMapper.toLocation(photographerDto.getLocations()));
        User returned = phtrRepo.save(photographer);
        return DtoMapper.toPhotographerInfoDto(returned);
    }

    public SearchDto searchPhotographer(String search, int page, int size) {
        Pageable paging = PageRequest.of(page, size);
        Page<User> photographers = phtrRepo.searchPhotographerNameContaining(search, paging, (long) 2);
        Page<ServicePackage> packages = packageRepository.findByNameContaining(search, paging);
        SearchDto searchDto = new SearchDto();
        searchDto.setPackages(packages.getContent());
        searchDto.setPhotographers(photographers.getContent());
        return searchDto;
    }

    //filter photographer theo location (load các photographer ở trong khu vực)
    public List<User> filterByLocation(double lat, double lon, List<User> photographers) {
        List<User> results = new ArrayList<>();
        try {
            // get lat lon location
            String uri = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + lon + "&key=AIzaSyBP8cODYx872X1l-6jqxTjLClHXdIoAUi4";
            HttpRequest request = HttpRequest.newBuilder()
                    .GET()
                    .uri(URI.create(uri))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            ObjectMapper objectMapper = new ObjectMapper();
            SearchLocationRequest locationRequest = objectMapper.readValue(response.body(), SearchLocationRequest.class);

            String location = locationRequest.getPlusCode().getCompoundCode();

            // filter photographer có vị trí phù hợp
            for(User photographer : photographers) {
                if(isPhotographerInLocation(photographer, location)) {
                    results.add(photographer);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return results;
    }

    private boolean isPhotographerInLocation(User photographer, String location) {
        try {
            for(Location locationObj : photographer.getLocations()) {
                if(StringUtils.ContainsWord(location, locationObj.getFormattedAddress().split(","))) {
                    return true;
                }
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }

    public Calendar getCalendar(long ptgId) {
        Calendar result = new Calendar();
        List<Date> bookingDates = new ArrayList<>();
        List<Date> busyDays = new ArrayList<>();

        //query booking ongoing + editing
        List<Booking> bookings = bookingRepository.findOnGoingNEditingBookingsBetween(ptgId);
        // map booking to bookinginfo
        for(Booking b : bookings) {
            bookingDates.add(b.getEditDeadline());
            for(TimeLocationDetail tld : b.getTimeLocationDetails()) {
                bookingDates.add(tld.getStart());
            }
        }

        // query busy days
        List<BusyDay> busyQuery = busyDayRepository.findAllByPhotographerId(ptgId);
        for(BusyDay busyDay : busyQuery) {
            busyDays.add(busyDay.getStartDate());
        }

        // add not working days to busy days

        // query working days
        List<DayOfWeek> workingDays = workingDayRepository.findNotWorkingDayByPhotographerId(ptgId);
        List<java.time.DayOfWeek> dows = new ArrayList<>();
        for(DayOfWeek dow : workingDays) {
            dows.add(DateHelper.getNotWorkingDay(dow));
        }

        List<LocalDate> datesBetween = DateHelper.getDatesBetweenUsingJava9(LocalDate.of(2020, 12, 1), LocalDate.of(2021, 5, 31));
        for(LocalDate date : datesBetween) {
            for(java.time.DayOfWeek dow : dows) {
                if(DateHelper.isDateDayOfWeek(date, dow)) {
                    String fromString = date.toString() + " 00:00";
                    String toString = date.toString() + " 23:59";
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    LocalDateTime localFrom = LocalDateTime.parse(fromString, formatter);
                    LocalDateTime localTo = LocalDateTime.parse(toString, formatter);
                    if(bookingRepository.countOngoingNEditOnDate(DateHelper.convertToDateViaInstant(localFrom), DateHelper.convertToDateViaInstant(localTo)) == 0) {
                        busyDays.add(DateHelper.convertToDateViaInstant(date));
                    }
                }
            }
        }

        // add to calendar
        result.setBookingDates(bookingDates);
        result.setBusyDays(busyDays);
        return result;
    }

    public Calendar getCalendarForCustomer(long ptgId) {
        Calendar result = new Calendar();
        List<Date> bookingDates = new ArrayList<>();
        List<Date> busyDays = new ArrayList<>();

        //query booking ongoing + editing
        List<Booking> bookings = bookingRepository.findOnGoingBookingsBetween(ptgId);
        // map booking to bookinginfo
        for(Booking b : bookings) {
            for(TimeLocationDetail tld : b.getTimeLocationDetails()) {
                bookingDates.add(tld.getStart());
            }
        }

        // query busy days
        List<BusyDay> busyQuery = busyDayRepository.findAllByPhotographerId(ptgId);
        for(BusyDay busyDay : busyQuery) {
            busyDays.add(busyDay.getStartDate());
        }

        // add not working days to busy days

        // query working days
        List<DayOfWeek> workingDays = workingDayRepository.findNotWorkingDayByPhotographerId(ptgId);
        List<java.time.DayOfWeek> dows = new ArrayList<>();
        for(DayOfWeek dow : workingDays) {
            dows.add(DateHelper.getNotWorkingDay(dow));
        }

        List<LocalDate> datesBetween = DateHelper.getDatesBetweenUsingJava9(LocalDate.of(2020, 12, 1), LocalDate.of(2021, 5, 31));
        for(LocalDate date : datesBetween) {
            for(java.time.DayOfWeek dow : dows) {
                if(DateHelper.isDateDayOfWeek(date, dow)) {
                    String fromString = date.toString() + " 00:00";
                    String toString = date.toString() + " 23:59";
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    LocalDateTime localFrom = LocalDateTime.parse(fromString, formatter);
                    LocalDateTime localTo = LocalDateTime.parse(toString, formatter);
                    if(bookingRepository.countOngoingNEditOnDate(DateHelper.convertToDateViaInstant(localFrom), DateHelper.convertToDateViaInstant(localTo)) == 0) {
                        busyDays.add(DateHelper.convertToDateViaInstant(date));
                    }
                }
            }
        }

        // add to calendar
        result.setBookingDates(bookingDates);
        result.setBusyDays(busyDays);
        return result;
    }

    public DayEvent getPhotographerEventOnDay(long ptgId, String date) {
        DayEvent dayEvent = new DayEvent();
        Date from;
        Date to;
        List<BusyDay> busyDays;
        List<Booking> bookings;
        List<BookingInfo> bookingInfos = new ArrayList<>();
        try {
            String fromStr = date + " 00:00";
            String toStr = date + " 23:59";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
            LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
            from = DateHelper.convertToDateViaInstant(localFrom);
            to = DateHelper.convertToDateViaInstant(localTo);
            busyDays = busyDayRepository.findByPhotographerIdBetweenStartDateEndDate(ptgId, from, to);

            if(busyDays.size() > 0) {
                dayEvent.setBusyDays(busyDays);
                dayEvent.setBusyDay(true);
            } else {
                // find on going booking
                bookings = bookingRepository.findOngoingBookingOnDate(from, to, ptgId);
                for(Booking booking : bookings) {
                    for(TimeLocationDetail tld : booking.getTimeLocationDetails()) {
                        if(DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString().equalsIgnoreCase(date)) {
                            bookingInfos.add(DtoMapper.toBookingInfo(booking, tld));
                        }
                    }
                }

                // find editing booking
                bookings = bookingRepository.findEditingDeadlineOnDate(from, to, ptgId);
                for(Booking booking : bookings) {
                    bookingInfos.add(DtoMapper.toBookingInfo(booking));
                }

                if(bookingInfos.size() > 0) {
                    dayEvent.setBookingInfos(bookingInfos);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return dayEvent;
    }

    public DayEvent getPhotographerEventOnDayForCustomer(long ptgId, String date) {
        DayEvent dayEvent = new DayEvent();
        Date from;
        Date to;
        List<BusyDay> busyDays;
        List<Booking> bookings;
        List<BookingInfo> bookingInfos = new ArrayList<>();
        try {
            String fromStr = date + " 00:00";
            String toStr = date + " 23:59";
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
            LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
            from = DateHelper.convertToDateViaInstant(localFrom);
            to = DateHelper.convertToDateViaInstant(localTo);
            busyDays = busyDayRepository.findByPhotographerIdBetweenStartDateEndDate(ptgId, from, to);

            if(busyDays.size() > 0) {
                dayEvent.setBusyDays(busyDays);
                dayEvent.setBusyDay(true);
            } else {
                // find on going booking
                bookings = bookingRepository.findOngoingBookingOnDate(from, to, ptgId);
                for(Booking booking : bookings) {
                    for(TimeLocationDetail tld : booking.getTimeLocationDetails()) {
                        if(DateHelper.convertToLocalDateViaInstant(tld.getStart()).toString().equalsIgnoreCase(date)) {
                            bookingInfos.add(DtoMapper.toBookingInfo(booking, tld));
                        }
//                        bookingInfos.add(DtoMapper.toBookingInfo(booking, tld));
                    }
                }

                if(bookingInfos.size() > 0) {
                    dayEvent.setBookingInfos(bookingInfos);
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return dayEvent;
    }

    public List<DayOfWeek> editWorkingDay(long ptgId, List<DayOfWeek> dows) {
        List<DayOfWeek> results = new ArrayList<>();
        for(DayOfWeek dow : dows) {
            try {
                //query where photographer_id = and dow = dow

                //chua co -> create
                if(workingDayRepository.checkDowExists(ptgId, dow.getDay()) == 0) {
                    DayOfWeek dayOfWeek = new DayOfWeek();
                    dayOfWeek.setDay(dow.getDay());
                    dayOfWeek.setWorkingDay(dow.isWorkingDay());
                    dayOfWeek.setStartTime(dow.getStartTime());
                    dayOfWeek.setEndTime(dow.getEndTime());
                    User photographer = phtrRepo.findById(ptgId).get();
                    dayOfWeek.setPhotographer(photographer);
                    results.add(workingDayRepository.save(dayOfWeek));
                } else {
                    DayOfWeek dayOfWeek = workingDayRepository.findByPhotographerIdAndDay(ptgId, dow.getDay());
                    dayOfWeek.setWorkingDay(dow.isWorkingDay());
                    dayOfWeek.setStartTime(dow.getStartTime());
                    dayOfWeek.setEndTime(dow.getEndTime());
                    results.add(workingDayRepository.save(dayOfWeek));
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return results;
    }

    public List<DayOfWeek> createWorkingDay(long ptgId) {
        List<DayOfWeek> results = new ArrayList<>();
        for(int i = 1; i <= 7; i++) {
            DayOfWeek dayOfWeek = new DayOfWeek();
            dayOfWeek.setDay(i);
            dayOfWeek.setWorkingDay(true);
            LocalDateTime localStartTime = LocalDateTime.of(2020, Month.NOVEMBER, 1, 8, 00, 00);
            Date startTime = DateHelper.convertToDateViaInstant(localStartTime);
            LocalDateTime localEndTime = LocalDateTime.of(2020, Month.NOVEMBER, 1, 19, 00, 00);
            Date endTime = DateHelper.convertToDateViaInstant(localEndTime);
            dayOfWeek.setStartTime(startTime);
            dayOfWeek.setEndTime(endTime);
            User photographer = phtrRepo.findById(ptgId).get();
            dayOfWeek.setPhotographer(photographer);
            results.add(workingDayRepository.save(dayOfWeek));
        }
        return results;
    }

    public List<DayOfWeek> getWorkingDay(long ptgId) {
        return workingDayRepository.findAllByPhotographerId(ptgId);
    }

    public List<BusyDay> testBusyDays(Long ptgId) {
        return busyDayRepository.findAllByPhotographerId(ptgId);
    }

    public String deleteBusyDay(Long busyDayId) {
        busyDayRepository.deleteById(busyDayId);
        return "Delete success";
    }

    public List<Location> getPhotographerLocations(long userId) {
        return locationRepository.findAllByUserId(userId);
    }

    public Location addLocation(Location location) {
        Location result = locationRepository.save(location);
        return result;
    }

    public User updateProfile(User user) {
        User save = phtrRepo.findById(user.getId()).get();
        save.setFullname(user.getFullname());
        save.setLocations(user.getLocations());
        save.setEmail(user.getEmail());
        save.setPhone(user.getPhone());
        save.setDescription(user.getDescription());
        return phtrRepo.save(save);
    }

    public Boolean checkWorkingTime(String time, Long photographerId) {
        try {
            DayOfWeek dayOfWeek = workingDayRepository.findByPhotographerIdAndDay(photographerId, 1);
            LocalTime startTime = LocalTime.parse(dayOfWeek.getStartTime().toString());
            LocalTime endTime = LocalTime.parse(dayOfWeek.getEndTime().toString());
            LocalTime comparingTime = LocalTime.parse(time);
            if(startTime.compareTo(comparingTime) <= 0 && endTime.compareTo(comparingTime) >= 0) {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }
}

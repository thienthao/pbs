package fpt.university.pbswebapi.helper;

import fpt.university.pbswebapi.dto.*;
import fpt.university.pbswebapi.entity.*;

import java.util.ArrayList;
import java.util.List;

public class DtoMapper {

    public static PhotographerDto toPhotographerDto(User photographer) {
        List<AlbumDto2> albumDto2s = new ArrayList<>();
        for (Album album: photographer.getAlbums()) {
            albumDto2s.add(toAlbumDto(album));
        }

        List<ServicePackageDto> packageDtos = new ArrayList<>();
        for (ServicePackage servicePackage: photographer.getPackages()) {
            packageDtos.add(toServicePackageDto(servicePackage));
        }

        return new PhotographerDto(
                photographer.getId(),
                photographer.getUsername(),
                photographer.getFullname(),
                photographer.getDescription(),
                photographer.getAvatar(),
                photographer.getPhone(),
                photographer.getEmail(),
                photographer.getRatingCount(),
                albumDto2s,
                packageDtos,
                photographer.getCover(),
                photographer.getBooked()
        );
    }

    public static SplitedPhotographerDto toSplitedPhotographerDto(User photographer) {
        return new SplitedPhotographerDto(
                photographer.getId(),
                photographer.getUsername(),
                photographer.getFullname(),
                photographer.getDescription(),
                photographer.getAvatar(),
                photographer.getPhone(),
                photographer.getEmail(),
                photographer.getRatingCount(),
                photographer.getCover(),
                photographer.getBooked()
        );
    }

    public static AlbumDto2 toAlbumDto(Album album) {
        return new AlbumDto2(
                album.getId(),
                album.getName(),
                album.getThumbnail(),
                album.getLocation(),
                album.getDescription(),
                album.getLikes()
        );
    }

    public static ServicePackageDto toServicePackageDto(ServicePackage servicePackage) {
        List<ServiceDto> serviceDtos = new ArrayList<>();
        for(Service service : servicePackage.getServices()) {
            serviceDtos.add(toServiceDto(service));
        }

        return new ServicePackageDto(
                servicePackage.getId(),
                servicePackage.getName(),
                servicePackage.getPrice(),
                servicePackage.getDescription(),
                servicePackage.getSupportMultiDays(),
                serviceDtos
        );
    }

    public static ServiceDto toServiceDto(Service service) {
        return new ServiceDto(
                service.getId(),
                service.getName(),
                service.getDescription()
        );
    }

    public static Service toService(ServiceDto serviceDto) {
        return new Service(
          serviceDto.getName(),
          serviceDto.getDescription()
        );
    }

    public static ServicePackage toServicePackage(PackageJson packageJson) {
        User photographer = new User();
        photographer.setId(packageJson.getPhotographer());

        List<Service> services = new ArrayList<>();
        for(ServiceDto serviceDto : packageJson.getServices()) {
            services.add(toService(serviceDto));
        }

        return new ServicePackage(
                packageJson.getName(),
                packageJson.getPrice(),
                packageJson.getDescription(),
                photographer,
                services
        );
    }

    public static Album toAlbum(AlbumJson albumJson) {
        User photographer = new User();
        photographer.setId(albumJson.getPhotographer());

        List<Image> images = new ArrayList<>();
        for(ImageJson imageJson : albumJson.getImages()) {
            images.add(toImage(imageJson));
        }

        return new Album(
                albumJson.getName(),
                albumJson.getThumbnail(),
                albumJson.getLocation(),
                albumJson.getDescription(),
                photographer,
                images
        );
    }

    public static Image toImage(ImageJson imageJson) {
        return new Image(
                imageJson.getDescription(),
                imageJson.getImageLink(),
                imageJson.getComment()
        );
    }

    public static User toPhotographer(PhotographerInfoDto photographerInfoDto) {
        User user = new User();
        user.setId(photographerInfoDto.getId());
        user.setDescription(photographerInfoDto.getDescription());
        user.setEmail(photographerInfoDto.getEmail());
        user.setPhone(photographerInfoDto.getPhone());
        return user;
    }

    public static PhotographerInfoDto toPhotographerInfoDto(User photographer) {
        PhotographerInfoDto photographerInfoDto = new PhotographerInfoDto();
        photographerInfoDto.setId(photographer.getId());
        photographerInfoDto.setDescription(photographer.getDescription());
        photographerInfoDto.setEmail(photographer.getEmail());
        photographerInfoDto.setFullname(photographer.getFullname());
        photographerInfoDto.setPhone(photographer.getPhone());

        List<LocationDto> locationDtos = new ArrayList<>();
        for (Location location: photographer.getLocations()) {
            locationDtos.add(toLocationDto(location));
        }
        photographerInfoDto.setLocations(locationDtos);
        return photographerInfoDto;
    }

    public static LocationDto toLocationDto(Location location) {
        return new LocationDto(
                location.getId(),
                location.getFormattedAddress(),
                location.getLatitude(),
                location.getLongitude(),
                location.getUser().getId());
    }

    public static List<Location> toLocation(List<LocationDto> locationDtos) {
        List<Location> locations = new ArrayList<>();
        for(LocationDto locationDto : locationDtos) {
            Location location = new Location();
            location.setId(locationDto.getId());
            location.setFormattedAddress(locationDto.getFormattedAddress());
            location.setLatitude(locationDto.getLatitude());
            location.setLongitude(locationDto.getLongitude());
            User user = new User();
            user.setId(locationDto.getUserId());
            location.setUser(user);
            locations.add(location);
        }
        return locations;
    }

    public static BookingInfo toBookingInfo(Booking b, TimeLocationDetail tld) {
        BookingInfo bInfo = new BookingInfo();
        bInfo.setId(b.getId());
        bInfo.setStatus(b.getBookingStatus().toString());
        bInfo.setAddress(tld.getFormattedAddress());
        bInfo.setLat(tld.getLat());
        bInfo.setLon(tld.getLon());
        bInfo.setPackageName(b.getServiceName());
        bInfo.setPackagePrice(b.getPrice());
        bInfo.setCustomerId(b.getCustomer().getId());
        bInfo.setCustomerName(b.getCustomer().getFullname());
        bInfo.setStart(tld.getStart());
        bInfo.setEnd(tld.getEnd());
        return bInfo;
    }

    // for editing booking only
    public static BookingInfo toBookingInfo(Booking b) {
        BookingInfo bInfo = new BookingInfo();
        bInfo.setId(b.getId());
        bInfo.setStatus(b.getBookingStatus().toString());
        bInfo.setPackageName(b.getServiceName());
        bInfo.setPackagePrice(b.getPrice());
        bInfo.setCustomerId(b.getCustomer().getId());
        bInfo.setCustomerName(b.getCustomer().getFullname());
        bInfo.setStart(b.getEditDeadline());
        bInfo.setEnd(b.getEditDeadline());
        return bInfo;
    }
}

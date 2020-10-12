package fpt.university.pbswebapi.helper;

import fpt.university.pbswebapi.dto.*;
import fpt.university.pbswebapi.entity.Album;
import fpt.university.pbswebapi.entity.Service;
import fpt.university.pbswebapi.entity.ServicePackage;
import fpt.university.pbswebapi.entity.User;

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
}

package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PhotographerDto {
    private Long id;

    private String username;

    private String fullname;

    private String description;

    private String avatar;

    private String phone;

    private String email;

    private Float ratingCount;

    private List<AlbumDto2> albums;

    private List<ServicePackageDto> packages;

    private String cover;

    private Integer booked;
}

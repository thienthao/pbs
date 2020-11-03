package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.Location;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PhotographerInfoDto {
    private Long id;

    private String description;

    private String email;

    private String fullname;

    private String phone;

    private List<LocationDto> locations;

}

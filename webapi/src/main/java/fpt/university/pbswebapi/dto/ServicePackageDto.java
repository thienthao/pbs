package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ServicePackageDto {
    private Long id;

    private String name;

    private Integer price;

    private String description;

    private List<ServiceDto> serviceDtos;
}

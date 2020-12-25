package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.Category;
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

    private Integer timeAnticipate;

    private Integer price;

    private String description;

    private Boolean supportMultiDays;

    private List<ServiceDto> serviceDtos;

    private Category category;
}

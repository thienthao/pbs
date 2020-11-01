package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PackageJson {
    private String name;
    private Integer price;
    private String description;
    private Long photographer;
    private List<ServiceDto> services;
}
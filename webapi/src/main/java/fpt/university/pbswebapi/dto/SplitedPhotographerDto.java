package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SplitedPhotographerDto {
    private Long id;

    private String username;

    private String fullname;

    private String description;

    private String avatar;

    private String phone;

    private String email;

    private Double ratingCount;

    private String cover;

    private Integer booked;
}

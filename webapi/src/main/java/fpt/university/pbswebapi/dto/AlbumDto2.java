package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AlbumDto2 {
    private Long id;

    private String name;

    private String thumbnail;

    private String location;

    private String description;

    private Integer likes;

}

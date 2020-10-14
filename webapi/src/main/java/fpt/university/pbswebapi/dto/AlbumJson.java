package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AlbumJson {
    private String name;
    private String thumbnail;
    private String location;
    private String description;
    private Long photographer;
    private Long category;
    private List<ImageJson> images;
}

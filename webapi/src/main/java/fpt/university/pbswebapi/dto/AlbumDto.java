package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AlbumDto {
    private Long id;
    private String name;
    private String description;
    private Long ptgId;
    private Long categoryId;
}

package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ImageJson {
    private String description;
    private String imageLink;
    private String comment;
}

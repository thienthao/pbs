package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentDto {
    private String comment;
    private Float rating;
    private String username;
    private String fullname;
    private Date createdAt;
    private String location;
    private String avatar;
}

package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "images")
@Data
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "id"
)
@NoArgsConstructor
@AllArgsConstructor
public class Image {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String description;

    @Column(name = "image_link")
    private String imageLink;

    private String comment;

    @Column(name = "created_at")
    private Date createdAt;

    @ManyToMany(mappedBy = "images")
    private List<Album> albums;

    public Image(String description, String imageLink, String comment) {
        this.description = description;
        this.imageLink = imageLink;
        this.comment = comment;
    }
}

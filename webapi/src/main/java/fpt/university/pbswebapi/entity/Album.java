package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.Data;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "albums")
@Data
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "id"
)
public class Album {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String thumbnail;

    private String description;

    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @JsonIgnore
    @Column(name = "is_active")
    private Boolean isActive;

    @ManyToOne
    @JoinColumn(name = "photographer_id", referencedColumnName = "id")
    private User photographer;

    @ManyToMany
    @JoinTable(
            name = "albums_images",
            joinColumns = @JoinColumn(name = "album_id"),
            inverseJoinColumns = @JoinColumn(name = "image_id")
    )
    private List<Image> images;
}

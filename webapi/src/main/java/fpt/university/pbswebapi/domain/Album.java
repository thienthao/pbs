package fpt.university.pbswebapi.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity(name = "albums")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Album {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "thumbnail")
    private String thumbnail;

    @ManyToOne(optional = false)
    @JoinColumn(name = "PHOTOGRAPHER_ID", referencedColumnName = "ID")
    @JsonBackReference
    private Photographer photographer;

    @OneToMany
    private List<Photo> photos;

    private String style;

}

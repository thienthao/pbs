package fpt.university.pbswebapi.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity(name = "albums")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Album {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "image_link")
    private String imageLink;

    @Column(name = "image_caption")
    private String imageCaption;

    @ManyToOne(optional = false)
    @JoinColumn(name = "PHOTOGRAPHER_ID", referencedColumnName = "ID")
    @JsonBackReference
    private Photographer photographer;
}

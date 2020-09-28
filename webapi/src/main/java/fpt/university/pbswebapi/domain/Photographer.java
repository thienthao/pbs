package fpt.university.pbswebapi.domain;


import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name= "photographers")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Photographer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "rating_count")
    private String ratingCount;

    @Column(name = "description")
    private String description;

    @Column(name = "mail")
    private String mail;

    @Column(name = "phone")
    private String phone;

    @Column(name = "avatar")
    private String avatar;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "photographer")
    @JsonManagedReference
    private List<Album> albums;

    public Photographer(Long id, String name) {
        this.id = id;
        this.name = name;
    }
}

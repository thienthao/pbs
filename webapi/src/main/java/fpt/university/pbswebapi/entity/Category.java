package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "categories")
@Data
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String category;

    @Column(name = "icon_link")
    private String iconLink;

    @JsonIgnore
    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @JsonIgnore
    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;
}

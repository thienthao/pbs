package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity(name = "threads")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Thread {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String title;

    private String content;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;

    @ManyToOne
    @JoinColumn(name = "owner_id", referencedColumnName = "id")
    private User owner;

    @ManyToOne
    @JoinColumn(name = "topic_id", referencedColumnName = "id")
    private ThreadTopic topic;

    @OneToMany
    @JoinColumn(name = "thread_id", referencedColumnName = "id")
    @JsonManagedReference
    private List<ThreadComment> comments;

    @Column(name = "is_ban")
    private Boolean isBan;

    @Column(name = "is_deleted")
    private Boolean isDeleted;

    @PrePersist
    void prepersist() {
        isBan = false;
        createdAt = new Date();
        isDeleted = false;
    }
}

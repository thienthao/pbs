package fpt.university.pbswebapi.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "thread_topics")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ThreadTopic {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String topic;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;

    @Column(name = "is_available")
    private Boolean isAvailable;

    @PrePersist
    void prepersist() {
        isAvailable = true;
        createdAt = new Date();
    }

    @PreUpdate
    void preupdate() {
        updatedAt = new Date();
    }

}

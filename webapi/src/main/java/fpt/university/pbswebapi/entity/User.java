package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    private String username;

    private String fullname;

    @JsonIgnore
    private String password;

    private String description;

    private String avatar;

    private String cover;

    private Integer booked;

    private String phone;

    private String email;

    private Float ratingCount;

    @JsonIgnore
    @Column(name = "is_blocked")
    private Boolean isBlocked;

    @JsonIgnore
    @Column(name = "is_deleted")
    private Boolean isDeleted;

    @JsonIgnore
    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @JsonIgnore
    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "role_id", referencedColumnName = "id")
    private Role role;

    @JsonIgnore
    @OneToMany(mappedBy = "photographer")
    private List<Album> albums;

    @JsonIgnore
    @ManyToMany(mappedBy = "users")
    private List<Album> likedAlbums;

    @JsonIgnore
    @OneToMany(mappedBy = "photographer")
    private List<ServicePackage> packages;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id")
    private List<Location> locations;

    @Column(name = "device_token")
    private String deviceToken;

    @Transient
    @JsonSerialize
    private Double averagePackagePrice;

    @Transient
    @JsonSerialize
    private Double distance;

    @Column(name = "is_enabled")
    private Boolean isEnabled;

    public User(String username, String email, String password, String phone, String fullname) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.fullname = fullname;
    }

    @PrePersist
    void prepersist(){
        createdAt = new Date();
        isBlocked = false;
        isDeleted = false;
        isEnabled = false;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullname='" + fullname + '\'' +
                ", deviceToken='" + deviceToken + '\'' +
                '}';
    }
}

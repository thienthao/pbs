package fpt.university.pbswebapi.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "time_location_detail")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TimeLocationDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "latitude")
    private Double lat;

    @Column(name = "longitude")
    private Double lon;

    @Column(name = "formatted_address")
    private String formattedAddress;

    @Column(name = "start")
    private Date start;

    @Column(name = "end")
    private Date end;

}

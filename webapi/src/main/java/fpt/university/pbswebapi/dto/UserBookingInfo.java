package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserBookingInfo {

    private Integer numOfBooking;

    private Integer numOfCancelled;

    private Integer numOfDone;

    private Double cancellationRate;
}

package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserBookingInfoList {

    private User user;

    private UserBookingInfo userBookingInfo;
}

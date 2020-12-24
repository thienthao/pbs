package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.PhotographerInfoDto;
import fpt.university.pbswebapi.dto.UserBookingInfo;
import fpt.university.pbswebapi.dto.UserBookingInfoList;
import fpt.university.pbswebapi.entity.Booking;
import fpt.university.pbswebapi.entity.EBookingStatus;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.repository.BookingRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private static DecimalFormat df = new DecimalFormat("#.##");
    private UserRepository userRepository;

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @PostMapping("/{userId}/devicetoken")
    public void saveDeviceToken(@RequestBody String deviceToken,
                                @PathVariable("userId") long userId) {
        try {
            User user = userRepository.findById(userId).get();
            System.out.println(deviceToken);
            user.setDeviceToken(deviceToken);
            userRepository.save(user);
        } catch (Exception e) {
            throw new BadRequestException(e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<?> all() {
        return ResponseEntity.ok().body(userRepository.findAll());
    }

    @GetMapping("/booking-infos")
    public List<UserBookingInfoList> getUserList() {
        List<User> users = userRepository.findAll();
        List<UserBookingInfoList> userBookingInfoLists = new ArrayList<>();
        for(User user : users) {
            List<Booking> bookings = bookingRepository.findAllByUserId(user.getId());

            int numOfCancelled = 0;
            UserBookingInfo userBookingInfo = new UserBookingInfo();

            for(Booking booking : bookings) {
                if(booking.getBookingStatus() == EBookingStatus.CANCELED) {
                    numOfCancelled += 1;
                }
            }
            double cancellationRate = ((double) numOfCancelled / (double) bookings.size()) * 100;
            cancellationRate = Double.parseDouble(df.format(cancellationRate));
            userBookingInfo.setNumOfBooking(bookings.size());
            userBookingInfo.setNumOfCancelled(numOfCancelled);
            cancellationRate = Double.parseDouble(df.format(cancellationRate));
            userBookingInfo.setCancellationRate(cancellationRate);

            UserBookingInfoList userBookingInfoList = new UserBookingInfoList();
            userBookingInfoList.setUser(user);
            userBookingInfoList.setUserBookingInfo(userBookingInfo);
            userBookingInfoLists.add(userBookingInfoList);
        }
        return userBookingInfoLists;
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> findOne(@PathVariable Long id) {
        User user = userRepository.findById(id).get();
        return new ResponseEntity<>(user, HttpStatus.OK);
    }


    @PutMapping
    public ResponseEntity<?> editProfile(@RequestBody PhotographerInfoDto userDto) {
        User user = userRepository.findById(userDto.getId()).get();
        user.setFullname(userDto.getFullname());
        user.setEmail(userDto.getEmail());
        user.setPhone(userDto.getPhone());
        return new ResponseEntity<>(userRepository.save(user), HttpStatus.OK);
    }
}

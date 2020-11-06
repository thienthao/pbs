package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {
    private UserRepository userRepository;

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
}

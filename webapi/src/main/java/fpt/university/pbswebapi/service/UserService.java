package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void blockUser(long userId) {
        userRepository.blockUser(userId);
    }

    public void unblockUser(long userId) {
        userRepository.unblockUser(userId);
    }
}

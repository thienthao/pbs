package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.User;
import fpt.university.pbswebapi.exception.ResourceNotFoundException;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.security.CurrentUser;
import fpt.university.pbswebapi.security.UserPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/user/me")
    @PreAuthorize("hasRole('USER')")
    public User getCurrentUser(@CurrentUser UserPrincipal userPrincipal) {
        return userRepository.findById(userPrincipal.getId())
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userPrincipal.getId()));
    }
}
package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.OAuthUser;
import fpt.university.pbswebapi.exception.ResourceNotFoundException;
import fpt.university.pbswebapi.repository.OauthUserRepository;
import fpt.university.pbswebapi.security.CurrentUser;
import fpt.university.pbswebapi.security.UserPrincipal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {
    @Autowired
    private OauthUserRepository oauthUserRepository;

    @GetMapping("/user/me")
    @PreAuthorize("hasRole('USER')")
    public OAuthUser getCurrentUser(@CurrentUser UserPrincipal userPrincipal) {
        return oauthUserRepository.findById(userPrincipal.getId())
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userPrincipal.getId()));
    }
}
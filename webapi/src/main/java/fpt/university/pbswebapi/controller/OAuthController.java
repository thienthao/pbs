package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.AuthProvider;
import fpt.university.pbswebapi.domain.OAuthUser;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.payload.ApiResponse;
import fpt.university.pbswebapi.payload.AuthResponse;
import fpt.university.pbswebapi.payload.LoginRequest;
import fpt.university.pbswebapi.payload.SignUpRequest;
import fpt.university.pbswebapi.repository.OauthUserRepository;
import fpt.university.pbswebapi.security.TokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javax.validation.Valid;
import java.net.URI;

@RestController
@RequestMapping("/auth")
public class OAuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private OauthUserRepository oauthUserRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private TokenProvider tokenProvider;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getEmail(),
                        loginRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String token = tokenProvider.createToken(authentication);
        return ResponseEntity.ok(new AuthResponse(token));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignUpRequest signUpRequest) {
        if(oauthUserRepository.existsByEmail(signUpRequest.getEmail())) {
            throw new BadRequestException("Email address already in use.");
        }

        // Creating user's account
        OAuthUser OAuthUser = new OAuthUser();
        OAuthUser.setName(signUpRequest.getName());
        OAuthUser.setEmail(signUpRequest.getEmail());
        OAuthUser.setPassword(signUpRequest.getPassword());
        OAuthUser.setProvider(AuthProvider.local);

        OAuthUser.setPassword(passwordEncoder.encode(OAuthUser.getPassword()));

        OAuthUser result = oauthUserRepository.save(OAuthUser);

        URI location = ServletUriComponentsBuilder
                .fromCurrentContextPath().path("/user/me")
                .buildAndExpand(result.getId()).toUri();

        return ResponseEntity.created(location)
                .body(new ApiResponse(true, "User registered successfully@"));
    }
}

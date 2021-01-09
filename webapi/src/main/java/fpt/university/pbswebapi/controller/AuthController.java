package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.UserDto;
import fpt.university.pbswebapi.entity.ERole;
import fpt.university.pbswebapi.entity.Role;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.exception.NotFoundException;
import fpt.university.pbswebapi.payload.own.request.LoginRequest;
import fpt.university.pbswebapi.payload.own.request.SignupRequest;
import fpt.university.pbswebapi.payload.own.response.JwtResponse;
import fpt.university.pbswebapi.payload.own.response.MessageResponse;
import fpt.university.pbswebapi.repository.RoleRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.security.jwt.JwtUtils;
import fpt.university.pbswebapi.security.services.UserDetailsImpl;
import fpt.university.pbswebapi.service.PhotographerService;
import fpt.university.pbswebapi.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@Validated
@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthenticationManager authenticationManager;

    private final UserRepository userRepository;

    private final PhotographerService photographerService;

    private final RoleRepository roleRepository;

    private final PasswordEncoder encoder;

    private final JwtUtils jwtUtils;

    private final UserService userService;

    public AuthController(AuthenticationManager authenticationManager,
                          UserRepository userRepository,
                          PhotographerService photographerService,
                          RoleRepository roleRepository,
                          PasswordEncoder encoder,
                          JwtUtils jwtUtils,
                          UserService userService) {
        this.authenticationManager = authenticationManager;
        this.userRepository = userRepository;
        this.photographerService = photographerService;
        this.roleRepository = roleRepository;
        this.encoder = encoder;
        this.jwtUtils = jwtUtils;
        this.userService = userService;
    }

    @PostMapping("/signin")
    public ResponseEntity<?> authenticate(@Valid @RequestBody LoginRequest loginRequest) {
        Authentication authentication = null;
        try {
            authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword())
            );
        } catch (Exception e) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Tên đăng nhập hoặc mật khẩu không chính xác"));
        }

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();

        String role = userDetails.getAuthorities().toArray()[0].toString();

        return ResponseEntity.ok(new JwtResponse(
                jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                role));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signupRequest) {
        if (userRepository.existsByUsername(signupRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Tên đăng nhập đã tồn tại"));
        }

        if (userRepository.existsByEmail(signupRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Email đã tồn tại"));
        }

        User user = new User(signupRequest.getUsername(),
                signupRequest.getEmail(),
                encoder.encode(signupRequest.getPassword()),
                signupRequest.getPhone(),
                signupRequest.getFullname());

        String strRole = signupRequest.getRole();
        Role role;

        if (strRole == null) {
            role = roleRepository.findByRole(ERole.ROLE_CUSTOMER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
        } else {
            role = roleRepository.findByRole(ERole.valueOf(strRole))
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
        }

        user.setRole(role);
        user.setIsBlocked(false);
        user.setIsDeleted(false);
        User saved = userRepository.save(user);

        if (saved.getRole().getRole() == ERole.ROLE_PHOTOGRAPHER) {
            photographerService.createWorkingDay(saved.getId());
        }

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
    }

    @PutMapping(value = "/changePassword")
    public ResponseEntity<?> changePassword(@RequestBody @Valid UserDto user) {
        try {
            User updatedUser = userService.changeUserPassword(user);
            if (updatedUser == null) {
                return ResponseEntity.badRequest().body("Change password failed!");
            }
            return ResponseEntity.ok(new MessageResponse("Change password successfully!"));
        } catch (BadRequestException e) {
            return ResponseEntity.badRequest().body(new MessageResponse(e.getMessage()));
        } catch (NotFoundException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
}
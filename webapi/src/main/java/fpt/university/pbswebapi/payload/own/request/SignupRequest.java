package fpt.university.pbswebapi.payload.own.request;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import static fpt.university.pbswebapi.helper.StringUtils.*;

@Getter
@Setter
@NoArgsConstructor
public class SignupRequest {

    @NotBlank(message = "Username cannot be empty.")
    @Size(min = 8, max = 20, message = "Username is between [8-20] characters long.")
    private String username;

    @NotBlank(message = "Email cannot be empty.")
    @Size(max = 50, message = "Email only allows maximum 50 characters length.")
    @Email(regexp = EMAIL_REGEX, message = "Email does not match.")
    private String email;

    private String role;

    @NotBlank(message = "Full name cannot be empty.")
    @Pattern(regexp = FULL_NAME_REGEX, message = "Full name does not match.")
    private String fullname;

    @NotBlank(message = "Phone number cannot be empty.")
    @Pattern(regexp = PHONE_REGEX, message = "Phone number does not match.")
    private String phone;

    @NotBlank(message = "Password cannot be empty.")
    @Pattern(regexp = PASSWORD_REGEX, message = "New Password does not match.")
    private String password;
}

package fpt.university.pbswebapi.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import static fpt.university.pbswebapi.helper.StringUtils.PASSWORD_REGEX;

@Getter
@Setter
@NoArgsConstructor
public class UserDto {

    @NotBlank(message = "Username cannot be empty.")
    @Size(min = 8, max = 20, message = "Username is between [8-20] characters long.")
    private String username;

    @NotBlank(message = "Old Password cannot be empty.")
    @Pattern(regexp = PASSWORD_REGEX, message = "Old Password does not match.")
    private String oldPassword;

    @NotBlank(message = "New Password cannot be empty.")
    @Pattern(regexp = PASSWORD_REGEX, message = "New Password does not match.")
    private String newPassword;
}

package fpt.university.pbswebapi.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Getter
@Setter
@NoArgsConstructor
public class UserDto {
    private static final String PASSWORD_REGEX = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";

    @NotNull
    @Size(min = 8, max = 20)
    private String username;

    @NotNull
    @NotBlank
    @Size(min = 8)
    @Pattern(regexp = PASSWORD_REGEX)
    private String oldPassword;

    @NotNull
    @NotBlank
    @Size(min = 8)
    @Pattern(regexp = PASSWORD_REGEX)
    private String newPassword;
}

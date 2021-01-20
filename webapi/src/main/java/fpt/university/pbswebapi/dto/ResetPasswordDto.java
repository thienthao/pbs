package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.helper.StringUtils;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

@Data
@NoArgsConstructor
public class ResetPasswordDto {

    @NotBlank(message = "Email không được bỏ trống.")
    @Size(max = 50, message = "Email có độ dài tối đa là 50 ký tự.")
    @Pattern(regexp = StringUtils.EMAIL_REGEX, message = "Email không hợp lệ.")
    private String email;
}

package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.User;
import org.springframework.web.util.UriComponentsBuilder;

public class ResetPasswordEmailContext extends AbstractEmailContext {

    private String token;

    @Override
    public <T> void init(T context) {
        User user = (User) context;
        put("fullname", user.getFullname());
        setSubject("Yêu cầu thay đổi mật khẩu");
        setTo(user.getEmail());
    }

    public void setToken(String token) {
        this.token = token;
        put("token", token);
    }

    public void buildVerificationUrl(final String baseURL, final String token) {
        final String url = UriComponentsBuilder.fromHttpUrl(baseURL)
                .path("/auth/password/reset").queryParam("token", token).toUriString();
        put("verificationURL", url);
        buildEmailContent(getContext().get("fullname").toString(), url);
    }

    private void buildEmailContent(String fullname, String verifyURL) {
        String emailContent = "Xin chào <b>[[name]]</b>,<br>"
                + "Chúng tôi nhận được yêu cầu đặt lại mật khẩu từ email của bạn.<br>"
                + "Nhấn vào đường dẫn bên dưới để xác nhận đặt lại mật khẩu của bạn.<br>"
                + "Một email với mật khẩu mới sẽ được gửi đến bạn sau khi yêu cầu được xác nhận:<br>"
                + "<h3><a href=\"[[URL]]\" target=\"_self\">ĐẶT LẠI MẬT KHẨU</a></h3>"
                + "Cảm ơn,<br>"
                + "PBS Admin";
        emailContent = emailContent.replace("[[name]]", fullname);
        emailContent = emailContent.replace("[[URL]]", verifyURL);
        setContent(emailContent);
    }
}
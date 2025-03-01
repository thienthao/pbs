package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.User;
import org.springframework.web.util.UriComponentsBuilder;

public class AccountVerificationEmailContext extends AbstractEmailContext {

    private String token;

    @Override
    public <T> void init(T context) {
        User user = (User) context;
        put("fullname", user.getFullname());
        setSubject("Hoàn tất thủ tục đăng ký tài khoản");
        setTo(user.getEmail());
    }

    public void setToken(String token) {
        this.token = token;
        put("token", token);
    }

    public void buildVerificationUrl(final String baseURL, final String token){
        final String url= UriComponentsBuilder.fromHttpUrl(baseURL)
                .path("/auth/register/verify").queryParam("token", token).toUriString();
        put("verificationURL", url);
        buildEmailContent(getContext().get("fullname").toString(), url);
    }

    private void buildEmailContent(String fullname, String verifyURL) {
        String emailContent = "Xin chào <b>[[name]]</b>,<br>"
                + "Vui lòng nhấn vào đường dẫn bên dưới để kích hoạt tài khoản của bạn:<br>"
                + "<h3><a href=\"[[URL]]\" target=\"_self\">KÍCH HOẠT TÀI KHOẢN</a></h3>"
                + "Cảm ơn,<br>"
                + "PBS Admin";
        emailContent = emailContent.replace("[[name]]", fullname);
        emailContent = emailContent.replace("[[URL]]", verifyURL);
        setContent(emailContent);
    }
}
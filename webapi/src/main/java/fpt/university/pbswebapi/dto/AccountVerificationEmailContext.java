package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.User;
import org.springframework.web.util.UriComponentsBuilder;

public class AccountVerificationEmailContext extends AbstractEmailContext {

    private String token;

    @Override
    public <T> void init(T context) {
        User user = (User) context;
        put("fullname", user.getFullname());
        setSubject("Complete your registration");
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
    }
}
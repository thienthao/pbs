package fpt.university.pbswebapi.security.oauth2;

import fpt.university.pbswebapi.domain.AuthProvider;
import fpt.university.pbswebapi.domain.OAuthUser;
import fpt.university.pbswebapi.exception.OAuth2AuthenticationProcessingException;
import fpt.university.pbswebapi.repository.OauthUserRepository;
import fpt.university.pbswebapi.security.UserPrincipal;
import fpt.university.pbswebapi.security.oauth2.user.OAuth2UserInfo;
import fpt.university.pbswebapi.security.oauth2.user.OAuth2UserInfoFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Optional;

@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    @Autowired
    private OauthUserRepository oauthUserRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User =  super.loadUser(userRequest);

        try {
            return processOAuth2User(userRequest, oAuth2User);
        } catch (AuthenticationException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new InternalAuthenticationServiceException(ex.getMessage(), ex.getCause());
        }
    }

    private OAuth2User processOAuth2User(OAuth2UserRequest oAuth2UserRequest, OAuth2User oAuth2User) {
        OAuth2UserInfo oAuth2UserInfo = OAuth2UserInfoFactory.getOAuth2UserInfo(oAuth2UserRequest.getClientRegistration().getRegistrationId(), oAuth2User.getAttributes());
        if(StringUtils.isEmpty(oAuth2UserInfo.getEmail())) {
            throw new OAuth2AuthenticationProcessingException("Email not found from OAuth2 provider");
        }

        Optional<OAuthUser> userOptional = oauthUserRepository.findByEmail(oAuth2UserInfo.getEmail());
        OAuthUser OAuthUser;
        if(userOptional.isPresent()) {
            OAuthUser = userOptional.get();
            if(!OAuthUser.getProvider().equals(AuthProvider.valueOf(oAuth2UserRequest.getClientRegistration().getRegistrationId()))) {
                throw new OAuth2AuthenticationProcessingException("Looks like you're signed up with " +
                        OAuthUser.getProvider() + " account. Please use your " + OAuthUser.getProvider() +
                        " account to login.");
            }
            OAuthUser = updateExistingUser(OAuthUser, oAuth2UserInfo);
        } else {
            OAuthUser = registerNewUser(oAuth2UserRequest, oAuth2UserInfo);
        }
        return UserPrincipal.create(OAuthUser, oAuth2User.getAttributes());
    }

    private OAuthUser registerNewUser(OAuth2UserRequest oAuth2UserRequest, OAuth2UserInfo oAuth2UserInfo) {
        OAuthUser OAuthUser = new OAuthUser();

        OAuthUser.setProvider(AuthProvider.valueOf(oAuth2UserRequest.getClientRegistration().getRegistrationId()));
        OAuthUser.setProviderId(oAuth2UserInfo.getId());
        OAuthUser.setName(oAuth2UserInfo.getName());
        OAuthUser.setEmail(oAuth2UserInfo.getEmail());
        OAuthUser.setImageUrl(oAuth2UserInfo.getImageUrl());
        return oauthUserRepository.save(OAuthUser);
    }

    private OAuthUser updateExistingUser(OAuthUser existingOAuthUser, OAuth2UserInfo oAuth2UserInfo) {
        existingOAuthUser.setName(oAuth2UserInfo.getName());
        existingOAuthUser.setImageUrl(oAuth2UserInfo.getImageUrl());
        return oauthUserRepository.save(existingOAuthUser);
    }
}

package fpt.university.pbswebapi.security;

import fpt.university.pbswebapi.domain.OAuthUser;
import fpt.university.pbswebapi.exception.ResourceNotFoundException;
import fpt.university.pbswebapi.repository.OauthUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    OauthUserRepository oauthUserRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        OAuthUser OAuthUser = oauthUserRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + email));
        return UserPrincipal.create(OAuthUser);
    }

    @Transactional
    public UserDetails loadUserById(Long id) {
        OAuthUser OAuthUser = oauthUserRepository.findById(id).orElseThrow(
                () -> new ResourceNotFoundException("User", "id", id)
        );
        return UserPrincipal.create(OAuthUser);
    }
}

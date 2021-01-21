package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.VerificationToken;
import fpt.university.pbswebapi.repository.VerificationTokenRepository;
import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.security.crypto.keygen.BytesKeyGenerator;
import org.springframework.security.crypto.keygen.KeyGenerators;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.nio.charset.Charset;
import java.time.LocalDateTime;

@Service
public class VerificationTokenService {

    private static final BytesKeyGenerator DEFAULT_TOKEN_GENERATOR = KeyGenerators.secureRandom(50);
    private static final Charset US_ASCII = Charset.forName("US-ASCII");

    private final VerificationTokenRepository tokenRepository;

    public VerificationTokenService(VerificationTokenRepository tokenRepository) {
        this.tokenRepository = tokenRepository;
    }

    public VerificationToken createVerificationToken(int tokenValidityInSeconds) {
        String tokenValue = new String(Base64.encodeBase64URLSafe(DEFAULT_TOKEN_GENERATOR.generateKey()), US_ASCII);
        VerificationToken verificationToken = new VerificationToken();
        verificationToken.setToken(tokenValue);
        verificationToken.setExpireAt(LocalDateTime.now().plusSeconds(tokenValidityInSeconds));
        return this.saveToken(verificationToken);
    }

    public VerificationToken saveToken(VerificationToken verificationToken) {
        return tokenRepository.save(verificationToken);
    }

    public VerificationToken findByToken(String token) {
        return tokenRepository.findByToken(token);
    }

    public void removeToken(VerificationToken verificationToken) {
        tokenRepository.delete(verificationToken);
    }

    public void removeByToken(String token) {
        tokenRepository.removeByToken(token);
    }

    @Transactional
    public void removeAllExpiredToken() {
        tokenRepository.removeAllByExpireAtBefore(LocalDateTime.now());
    }
}

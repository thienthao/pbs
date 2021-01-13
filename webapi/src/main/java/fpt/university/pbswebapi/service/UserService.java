package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.AccountVerificationEmailContext;
import fpt.university.pbswebapi.dto.UserDto;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.entity.VerificationToken;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.exception.InvalidTokenException;
import fpt.university.pbswebapi.exception.NotFoundException;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import javax.mail.MessagingException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@Service
public class UserService {

    private final UserRepository userRepository;

    private final PasswordEncoder encoder;

    private final VerificationTokenService tokenService;

    private final EmailService emailService;

    @Autowired
    public UserService(UserRepository userRepository,
                       PasswordEncoder encoder,
                       VerificationTokenService tokenService,
                       EmailService emailService) {
        this.userRepository = userRepository;
        this.encoder = encoder;
        this.tokenService = tokenService;
        this.emailService = emailService;
    }

    public void blockUser(long userId) {
        userRepository.blockUser(userId);
    }

    public void unblockUser(long userId) {
        userRepository.unblockUser(userId);
    }

    public Page<User> getUserList(Pageable pageable, String start, String end, String role) {
        switch (role) {
            case "customer":
                if (start.equalsIgnoreCase("") || end.equalsIgnoreCase("")) {
                    return userRepository.getCustomer(pageable);
                }
                return getCustomerByDate(pageable, start, end);
            case "photographer":
                if (start.equalsIgnoreCase("") || end.equalsIgnoreCase("")) {
                    return userRepository.getPhotographer(pageable);
                }
                return getPhotographerByDate(pageable, start, end);
            default:
                if (start.equalsIgnoreCase("") || end.equalsIgnoreCase("")) {
                    return userRepository.getPhotographerAndCustomer(pageable);
                }
                return getPhotographerAndCustomerByDate(pageable, start, end);
        }
    }

    public void sendRegistrationConfirmationEmail(User user, String baseURL) throws MessagingException {
        VerificationToken verificationToken = tokenService.createVerificationToken();
        verificationToken.setUser(user);
        tokenService.saveToken(verificationToken);

        AccountVerificationEmailContext emailContext = new AccountVerificationEmailContext();
        emailContext.init(user);
        emailContext.setToken(verificationToken.getToken());
        emailContext.buildVerificationUrl(baseURL, verificationToken.getToken());
        emailService.sendVerificationMail(emailContext);
    }

    public boolean verifyUserAccount(String token) throws InvalidTokenException {
        VerificationToken verificationToken = tokenService.findByToken(token);
        if (ObjectUtils.isEmpty(verificationToken) ||
                !verificationToken.getToken().equals(token) ||
                verificationToken.isExpired()) {
            throw new InvalidTokenException("Mã xác nhận không hợp lệ.");
        }
        User user = userRepository.getOne(verificationToken.getUser().getId());
        if (ObjectUtils.isEmpty(user)) {
            return false;
        }
        user.setIsEnabled(true);
        userRepository.save(user);
        tokenService.removeToken(verificationToken);
        return true;
    }

    public User changeUserPassword(UserDto userDto) throws NotFoundException {
        User existedUser = userRepository.findByUsernameAndIsDeletedFalseAndIsBlockedFalse(userDto.getUsername());
        if (existedUser == null) {
            throw new NotFoundException();
        }
        if (!encoder.matches(userDto.getOldPassword(), existedUser.getPassword())) {
            throw new BadRequestException("Tên đăng nhập hoặc mật khẩu không chính xác");
        }
        existedUser.setPassword(encoder.encode(userDto.getNewPassword()));
        return userRepository.save(existedUser);
    }

    private Page<User> getCustomerByDate(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return userRepository.getCustomerByDate(pageable, from, to);
    }

    private Page<User> getPhotographerByDate(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return userRepository.getPhotographerByDate(pageable, from, to);
    }

    private Page<User> getPhotographerAndCustomerByDate(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return userRepository.getPhotographerAndCustomerByDate(pageable, from, to);
    }
}

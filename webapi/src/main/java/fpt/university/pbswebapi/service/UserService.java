package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.*;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.entity.VerificationToken;
import fpt.university.pbswebapi.exception.BadRequestException;
import fpt.university.pbswebapi.exception.InvalidTokenException;
import fpt.university.pbswebapi.exception.NotFoundException;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.helper.StringUtils;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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

    private final FCMService fcmService;

    @Value("${app.secure.token.validity}")
    private int accountActivationTokenValidity;

    @Value("${app.secure.token.password_reset}")
    private int ResetPasswordTokenValidity;

    @Autowired
    public UserService(UserRepository userRepository,
                       PasswordEncoder encoder,
                       VerificationTokenService tokenService,
                       EmailService emailService,
                       FCMService fcmService) {
        this.userRepository = userRepository;
        this.encoder = encoder;
        this.tokenService = tokenService;
        this.emailService = emailService;
        this.fcmService = fcmService;
    }

    public void blockUser(long userId) {
        userRepository.blockUser(userId);
        User user = userRepository.findById(userId).get();
        NotiRequest notiRequest = new NotiRequest();
        notiRequest.setTitle("Thông báo");
        notiRequest.setBody("Tài khoản của bạn đã bị vô hiệu hóa");
        notiRequest.setToken(user.getDeviceToken());
        fcmService.pushNotificationWithoutBooking(notiRequest);
    }

    public void unblockUser(long userId) {
        userRepository.unblockUser(userId);
    }

    public void enable(Long userId) {
        userRepository.enable(userId);
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
        VerificationToken verificationToken = tokenService.createVerificationToken(accountActivationTokenValidity);
        verificationToken.setUser(user);
        tokenService.saveToken(verificationToken);

        AccountVerificationEmailContext emailContext = new AccountVerificationEmailContext();
        emailContext.init(user);
        emailContext.setToken(verificationToken.getToken());
        emailContext.buildVerificationUrl(baseURL, verificationToken.getToken());
        emailService.sendMail(emailContext);
    }

    public void sendResetPasswordConfirmationEmail(User user, String baseURL) throws MessagingException {
        VerificationToken resetPasswordToken = tokenService.createVerificationToken(ResetPasswordTokenValidity);
        resetPasswordToken.setUser(user);
        tokenService.saveToken(resetPasswordToken);

        ResetPasswordEmailContext resetPasswordEmailContext = new ResetPasswordEmailContext();
        resetPasswordEmailContext.init(user);
        resetPasswordEmailContext.setToken(resetPasswordToken.getToken());
        resetPasswordEmailContext.buildVerificationUrl(baseURL, resetPasswordToken.getToken());
        emailService.sendMail(resetPasswordEmailContext);
    }

    public boolean verifyUserAccount(String token) throws InvalidTokenException {
        VerificationToken verificationToken = validateToken(token);
        User user = userRepository.getOne(verificationToken.getUser().getId());
        if (ObjectUtils.isEmpty(user)) {
            return false;
        }
        user.setIsEnabled(true);
        userRepository.save(user);
        tokenService.removeToken(verificationToken);
        return true;
    }

    public boolean resetPassword(String token) throws InvalidTokenException, MessagingException {
        VerificationToken verificationToken = validateToken(token);
        User user = userRepository.getOne(verificationToken.getUser().getId());
        if (ObjectUtils.isEmpty(user)) {
            return false;
        }

        // Create new password qualified with password regex pattern for user and save to DB
        // Remove verification token after new password has been save to DB
        final String newPassword = StringUtils.generateRandomPassword();
        System.out.println(newPassword);
        user.setPassword(encoder.encode(newPassword));
        userRepository.save(user);
        tokenService.removeToken(verificationToken);

        // Send new password to user email
        NewPasswordEmailContext emailContext = new NewPasswordEmailContext();
        emailContext.init(user);
        emailContext.buildEmailContent(user.getFullname(), newPassword);
        emailService.sendMail(emailContext);
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

    private VerificationToken validateToken(String token) throws InvalidTokenException {
        VerificationToken verificationToken = tokenService.findByToken(token);
        if (ObjectUtils.isEmpty(verificationToken) ||
                !verificationToken.getToken().equals(token) ||
                verificationToken.isExpired()) {
            throw new InvalidTokenException("Mã xác nhận không hợp lệ.");
        }
        return verificationToken;
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

    public void notifyChat(Long senderId, Long receiverId) {
        User sender = userRepository.findById(senderId).get();
        User receiver = userRepository.findById(receiverId).get();
        fcmService.pushNotificationChat(receiver.getDeviceToken(), sender.getFullname(), sender.getId(), receiver.getId());
    }
}

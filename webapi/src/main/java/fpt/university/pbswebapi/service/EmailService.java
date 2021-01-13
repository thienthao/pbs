package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.dto.AbstractEmailContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.nio.charset.StandardCharsets;

@Service
public class EmailService {

    private final JavaMailSender javaMailSender;

    @Value("${spring.mail.username}")
    private String sendFrom;

    @Autowired
    public EmailService(JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
    }

    public void sendVerificationMail(AbstractEmailContext email) throws MessagingException {
        MimeMessage mimeMessage = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage,
                MimeMessageHelper.MULTIPART_MODE_MIXED_RELATED,
                StandardCharsets.UTF_8.name());

        String fullname = email.getContext().get("fullname").toString();
        String verifyURL = email.getContext().get("verificationURL").toString();
        String emailContent = buildEmailContent(fullname, verifyURL);

        helper.setTo(email.getTo());
        helper.setSubject(email.getSubject());
        helper.setFrom(sendFrom);
        helper.setText(emailContent, true);
        javaMailSender.send(mimeMessage);
    }

    private String buildEmailContent(String fullname, String verifyURL) {
        String emailContent = "Xin chào <b>[[name]]</b>,<br>"
                + "Vui lòng nhấn vào đường dẫn bên dưới để kích hoạt tài khoản của bạn:<br>"
                + "<h3><a href=\"[[URL]]\" target=\"_self\">KÍCH HOẠT TÀI KHOẢN</a></h3>"
                + "Cảm ơn,<br>"
                + "PBS Admin";
        emailContent = emailContent.replace("[[name]]", fullname);
        emailContent = emailContent.replace("[[URL]]", verifyURL);
        return emailContent;
    }
}

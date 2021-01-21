package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.User;

public class NewPasswordEmailContext extends AbstractEmailContext {

    @Override
    public <T> void init(T context) {
        User user = (User) context;
        put("fullname", user.getFullname());
        setSubject("Mật khẩu mới đã được thay đổi");
        setTo(user.getEmail());
    }

    public void buildEmailContent(String fullname, String password) {
        String emailContent = "Xin chào <b>[[name]]</b>,<br>"
                + "Mật khẩu của bạn đã được đặt lại.<br>"
                + "Đây là mật khẩu mới của bạn, bạn có thể dùng mật khẩu này để đăng nhập vào hệ thống.<br>"
                + "<h3>[[PASSWORD]]</h3>"
                + "Cảm ơn,<br>"
                + "PBS Admin";
        emailContent = emailContent.replace("[[name]]", fullname);
        emailContent = emailContent.replace("[[PASSWORD]]", password);
        setContent(emailContent);
    }
}

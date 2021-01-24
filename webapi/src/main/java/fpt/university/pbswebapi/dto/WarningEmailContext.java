package fpt.university.pbswebapi.dto;

import fpt.university.pbswebapi.entity.User;

public class WarningEmailContext extends AbstractEmailContext{

    @Override
    public <T> void init(T context) {
        User user = (User) context;
        put("fullname", user.getFullname());
        setSubject("PBS - Cảnh báo!");
        setTo(user.getEmail());
    }

    public void buildEmailContent(String fullname) {
        String emailContent = "Xin chào <b>[[name]]</b>,<br>"
                + "Đây là cảnh báo về việc hành vị hủy hẹn của bạn.<br>"
                + "PBS Admin";
        emailContent = emailContent.replace("[[name]]", fullname);
        setContent(emailContent);
    }
}

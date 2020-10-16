package fpt.university.pbswebapi.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import fpt.university.pbswebapi.dto.NotiRequest;
import org.springframework.stereotype.Service;

@Service
public class FCMService {

    public String pushNotification(NotiRequest notiRequest) {
        Message message = Message.builder()
                .putData("content", notiRequest.getContent())
                .setToken(notiRequest.getFcmToken())
                .build();
        String response = null;
        try {
            response = FirebaseMessaging.getInstance().send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }
}

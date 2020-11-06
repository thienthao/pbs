package fpt.university.pbswebapi.service;

import com.google.firebase.messaging.AndroidConfig;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import fpt.university.pbswebapi.dto.NotiRequest;
import org.springframework.stereotype.Service;

@Service
public class FCMService {

    public String pushNotification(NotiRequest notiRequest) {
        Message message = Message.builder()
                .setToken(notiRequest.getToken())
                .setNotification(Notification.builder().setTitle(notiRequest.getTitle())
                    .setBody(notiRequest.getBody()).build())
                .putData("view", "booking_history")
                .putData("click_action", "FLUTTER_NOTIFICATION_CLICK")
                .putData("bookingId", "11")
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

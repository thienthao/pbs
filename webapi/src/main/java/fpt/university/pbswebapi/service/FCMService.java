package fpt.university.pbswebapi.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import fpt.university.pbswebapi.dto.NotiRequest;
import org.springframework.stereotype.Service;

@Service
public class FCMService {

    //                .setToken(notiRequest.getToken())
    public String pushNotification(NotiRequest notiRequest, Long bookingId, String topic) {
        Message message = Message.builder()
                .setTopic(topic)
                .setNotification(Notification.builder().setTitle(notiRequest.getTitle())
                    .setBody(notiRequest.getBody()).build())
                .putData("view", "booking_history")
                .putData("click_action", "FLUTTER_NOTIFICATION_CLICK")
                .putData("bookingId", bookingId.toString())
                .build();
        String response = null;
        try {
            response = FirebaseMessaging.getInstance().send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    public String pushNotification(NotiRequest notiRequest, Long bookingId) {
        Message message = Message.builder()
                .setToken(notiRequest.getToken())
                .setNotification(Notification.builder().setTitle(notiRequest.getTitle())
                        .setBody(notiRequest.getBody()).build())
                .putData("view", "booking_history")
                .putData("click_action", "FLUTTER_NOTIFICATION_CLICK")
                .putData("bookingId", bookingId.toString())
                .build();
        String response = null;
        try {
            response = FirebaseMessaging.getInstance().send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    public String pushNotificationWithoutBooking(NotiRequest notiRequest) {
        Message message = Message.builder()
                .setToken(notiRequest.getToken())
                .setNotification(Notification.builder().setTitle(notiRequest.getTitle())
                        .setBody(notiRequest.getBody()).build())
                .putData("view", "booking_history")
                .putData("click_action", "FLUTTER_NOTIFICATION_CLICK")
                .build();
        String response = null;
        try {
            response = FirebaseMessaging.getInstance().send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }

    public String pushNotificationChat(String receiverToken, String senderFullname, Long senderId, Long receiverId) {
        Message message = Message.builder()
                .setToken(receiverToken)
                .setNotification(Notification.builder().setTitle("Tin nhắn mới")
                        .setBody(senderFullname + " đã gửi tin nhắn cho bạn").build())
                .putData("sender", senderId.toString())
                .putData("receiver", receiverId.toString())
                .putData("click_action", "FLUTTER_NOTIFICATION_CLICK")
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

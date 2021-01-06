package fpt.university.pbswebapi.helper;

import org.springframework.stereotype.Component;

@Component
public class ThymeleafHelper {

    public static String convertStatus(String status) {
        switch (status) {
            case "CANCELLING_CUSTOMER":
                return "CHỜ_HỦY_KH";
            case "CANCELLING_PHOTOGRAPHER":
                return "CHỜ_HỦY_PTG";
            case "CANCELLED_PHOTOGRAPHER":
                return "ĐÃ_HỦY_PTG";
            case "CANCELLED_CUSTOMER":
                return "ĐÃ_HỦY_KH";
            case "CANCELLED_ADMIN":
                return "ĐÃ_HỦY_ADMIN";
            case "ADMIN_CANCELLED":
                return "ĐÃ_HỦY_ADMIN";
            case "PENDING":
                return "CHỜ_XÁC_NHẬN";
            case "ONGOING":
                return "SẮP_DIỄN_RA";
            case "EDITING":
                return "HẬU_KỲ";
            case "DONE":
                return "HOÀN_THÀNH";
            default:
                return "TRẠNG THÁI";
        }
    }

    public static String convertRole(String status) {
        switch (status) {
            case "ROLE_CUSTOMER":
                return "Khách hàng";
            case "ROLE_PHOTOGRAPHER":
                return "Photographer";
            case "ROLE_ADMIN":
                return "Quản trị viên";
            default:
                return "Khách hàng";
        }
    }
}

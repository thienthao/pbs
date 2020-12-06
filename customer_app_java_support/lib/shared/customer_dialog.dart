
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class CustomerDialog {
  void bookingSuccessDialog(BuildContext context, Function okButtonFunction, Function cancelButtonFunction) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AssetGiffyDialog(
          image: Image.asset(
            'assets/done_booking.gif',
            fit: BoxFit.cover,
          ),
          entryAnimation: EntryAnimation.DEFAULT,
          title: Text(
            'Hoàn thành',
            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
          description: Text(
            'Yêu cầu đã được gửi. Bạn có muốn đi đến màn hình chi tiết không?',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          onOkButtonPressed: okButtonFunction,
          onCancelButtonPressed: cancelButtonFunction,
          buttonOkColor: Theme.of(context).primaryColor,
          buttonOkText: Text(
            'Đồng ý',
            style: TextStyle(color: Colors.white),
          ),
          buttonCancelColor:
          Theme.of(context).scaffoldBackgroundColor,
          buttonCancelText: Text(
            'Không',
            style: TextStyle(color: Colors.black87),
          ),
        ));
  }

  void bookingFailDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AssetGiffyDialog(
          image: Image.asset(
            'assets/fail.gif',
            fit: BoxFit.cover,
          ),
          entryAnimation: EntryAnimation.DEFAULT,
          title: Text(
            'Thất bại',
            style: TextStyle(
                fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
          description: Text(
            'Đã có lỗi xảy ra trong lúc gửi yêu cầu.',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
          onlyOkButton: true,
          onOkButtonPressed: () {
            Navigator.pop(context);
          },

          buttonOkColor: Theme.of(context).primaryColor,
          buttonOkText: Text(
            'Xác nhận',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }


}
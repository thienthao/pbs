import 'package:flutter/material.dart';
import 'package:photographer_app/models/ongoing_model.dart';
import 'package:photographer_app/screens/booking_detail_screen_ongoing.dart';

class BuildTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        Task task = tasks[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 20.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 30.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 20.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 30.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 20.0,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        task.time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 19.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 20.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 30.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 20.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 30.0,
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        color: Colors.grey[300],
                        height: 1.2,
                        width: 20.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              animation = CurvedAnimation(
                                  parent: animation, curve: Curves.ease);
                              return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                  alignment: Alignment.center);
                            },
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation) {
                              return BookingDetailScreenOngoing();
                            }));
                  },
                  child: Container(
                    height: 200.0,
                    width: 260.0,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 120.0,
                                child: Text(
                                  task.taskname,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                height: 25.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Center(
                                    child: Text(
                                  "Sắp diễn ra",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.person,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: Text(
                                  'Khách hàng:',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  task.customer,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.loyalty,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: Text(
                                  'Gói:',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    task.package,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.location_on,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: Text(
                                  'Địa điểm:',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    task.address,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Row(
            //   children: <Widget>[
            //     SizedBox(width: 15.0),
            //     Text(
            //       task.time,
            //       style: TextStyle(
            //         color: Colors.black87,
            //         fontSize: 18.0,
            //       ),
            //     ),
            //     SizedBox(width: 15.0),
            //     _getTime(task, context),
            //     SizedBox(width: 15.0),
            //     Text(
            //       task.taskname,
            //       style: TextStyle(
            //         color: Colors.black87,
            //         fontSize: 18.0,
            //       ),
            //     ),
            //     SizedBox(width: 10.0),
            //     Container(
            //             height: 25.0,
            //             width: 80.0,
            //             decoration: BoxDecoration(
            //               color: Colors.lightBlueAccent,
            //               borderRadius: BorderRadius.circular(5.0),
            //             ),
            //             child: Center(
            //                 child: Text(
            //               "Sắp diễn ra",
            //               style: TextStyle(color: Colors.white),
            //             )),
            //           ),
            //   ],
            // ),
            SizedBox(height: 20.0),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Container(
            //       margin: EdgeInsets.only(left: 117.0, bottom: 20.0),
            //       width: 2,
            //       height: 120.0,
            //       color: Color(0xFF6C7174),
            //     ),
            //     SizedBox(width: 28.0),
            //     Flexible(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Row(
            //             children: <Widget>[
            //               Icon(
            //                 Icons.person,
            //                 color: Theme.of(context).primaryColor,
            //                 size: 20.0,
            //               ),
            //               SizedBox(width: 8.0),
            //               Text(
            //                 task.customer,
            //                 style: TextStyle(
            //                   color: Color(0xFF6C7174),
            //                   fontSize: 15.0,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           SizedBox(height: 6.0),
            //           Row(
            //             children: <Widget>[
            //               Icon(
            //                 Icons.loyalty,
            //                 color: Theme.of(context).primaryColor,
            //                 size: 20.0,
            //               ),
            //               SizedBox(width: 8.0),
            //               Text(
            //                 task.type,
            //                 style: TextStyle(
            //                   color: Color(0xFF6C7174),
            //                   fontSize: 15.0,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           SizedBox(height: 6.0),
            //           Row(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               Icon(
            //                 Icons.location_on,
            //                 color: Theme.of(context).primaryColor,
            //                 size: 20.0,
            //               ),
            //               SizedBox(width: 8.0),
            //               Flexible(
            //                 child: Text(
            //                   task.address,
            //                   style: TextStyle(
            //                     color: Color(0xFF6C7174),
            //                     fontSize: 15.0,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //           SizedBox(height: 6.0),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        );
      },
    );
  }

  _getTime(Task booking, context) {
    return Container(
      height: 25.0,
      width: 25.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
      ),
      child: _getChild(booking, context),
    );
  }

  _getChild(Task booking, context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

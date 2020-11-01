import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:photographer_app_1_11/models/vacation_model.dart';
import 'package:photographer_app_1_11/screens/date_vacation_pick.dart';
import 'package:photographer_app_1_11/widgets/working_date/bottom_sheet_daily.dart';

class ListVacation extends StatefulWidget {
  @override
  _ListVacationState createState() => _ListVacationState();
}

class _ListVacationState extends State<ListVacation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Lịch làm việc của tôi',
          style: TextStyle(
            fontSize: 30.0,
            letterSpacing: -2,
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  onPressedButton();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: 130.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: FlatButton.icon(
                        label: Text('Hằng tuần'),
                        icon: Icon(
                          Icons.calendar_today_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VacationPicker()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: 130.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 5,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: vacations.length,
              itemBuilder: (BuildContext context, int index) {
                Vacation vacation = vacations[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.3,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 5,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 120.0,
                            child: Text(
                              vacation.name,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.timer,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                ),
                                child: Text(
                                  'Thời gian:',
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
                                  vacation.date,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  secondaryActions: [
                    IconSlideAction(
                      caption: "Xóa",
                      color: Theme.of(context).primaryColor,
                      icon: Icons.close,
                      onTap: () {},
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onPressedButton() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          color: Color(0xFF737373),
          child: Container(
            child: BottomSheetDaily(),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

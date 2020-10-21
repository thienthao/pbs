import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:photographer_app/models/vacation_model.dart';

import 'date_vacation_pick.dart';

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
          'Ngày nghỉ của tôi',
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VacationPicker()),
              );
            },
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
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
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
                      borderRadius: BorderRadius.circular(20.0),
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
}

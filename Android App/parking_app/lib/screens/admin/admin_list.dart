import 'package:parking_app/models/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AdminList extends StatefulWidget {
  const AdminList({Key? key}) : super(key: key);

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  @override
  Widget build(BuildContext context) {
    final time = Provider.of<List<Time>?>(context);
    print(time);

    return ListView.builder(
      itemCount: time?.length ?? 0,
      itemBuilder: (context, index) {
        DateTime dateTime = DateTime.parse(time![index].time!);
        DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        String formattedDateTime = dateFormat.format(dateTime);
        return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              color: Color.fromARGB(255, 73, 100, 116),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: AssetImage('assets/car_icon.png'),
                ),
                title: Text(formattedDateTime,
                    style:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                subtitle: Text(
                  time[index].status == 'Parked'
                      ? 'Car ${time[index].license_plate} had parked'
                      : 'Car ${time[index].license_plate} had left',
                  style: TextStyle(
                      color: time[index].status == 'Parked'
                          ? Color.fromARGB(255, 41, 175, 15)
                          : Color.fromARGB(255, 118, 15, 18)),
                ),
              ),
            ));
      },
    );
  }
}

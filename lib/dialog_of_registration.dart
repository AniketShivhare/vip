import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:e_commerce/shopTime_weekDays_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var open_time_controller = TextEditingController();
var close_time_controller = TextEditingController();

List<TextEditingController> other_open_time_controllers = [];
List<TextEditingController> other_close_time_controllers = [];

bool isshopTimeDone = false;

class SimpleCustomAlert extends StatefulWidget {
  final Function updateParentState;
  SimpleCustomAlert({required this.updateParentState}) : super();

  @override
  _SimpleCustomAlertState createState() => _SimpleCustomAlertState();
}

class _SimpleCustomAlertState extends State<SimpleCustomAlert> {
  late List<Map<String, dynamic>> openingHours;

  @override
  void initState() {
    super.initState();
    openingHours = _generateOpeningHours();
  }

  List<Map<String, dynamic>> _generateOpeningHours() {
    return List.generate(
      7,
          (index) => {'day': _getDayName(index), 'times': <String>[]},
    );
  }

  String _getDayName(int index) {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[index];
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: openingHours.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(openingHours[index]['day']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (openingHours[index]['times'] != null &&
                            openingHours[index]['times']!.isNotEmpty)
                          Column(
                            children: (openingHours[index]['times']! as List<String>)
                                .map((time) => Text(time))
                                .toList(),
                          ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showTimePicker(context, index);
                      },
                      child: Text('Add Time'),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Call the save function here
                _saveOpeningHours();
              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context, int index) async {
    TimeOfDay? openingTime = await _selectTime(context, 'Opening Time');
    TimeOfDay? closingTime = await _selectTime(context, 'Closing Time');

    if (openingTime != null && closingTime != null) {
      setState(() {
        openingHours[index]['times']!.add(
          'Opening Time: ${_formatTime(openingTime)} - Closing Time: ${_formatTime(closingTime)}',
        );
      });
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context, String title) async {
    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ));
                },
                child: Text('Select Time'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }


  // Function to save opening hours
  void _saveOpeningHours() {
    print('Opening hours saved: $openingHours');
    Navigator.pop(context);
  }
}






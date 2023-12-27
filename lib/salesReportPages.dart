// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesReportPages extends StatefulWidget {
  const SalesReportPages({super.key});

  @override
  State<SalesReportPages> createState() => _SalesReportPagesState();
}

class _SalesReportPagesState extends State<SalesReportPages> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sales Overview'),
              InkWell(
                  child: Icon(Icons.edit_calendar_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => daysRangeSalesOverview()),
                    );
                  })
            ],
          ),
          bottom: TabBar(tabs: [
            Tab(
              text: 'Daily',
            ),
            Tab(
              text: 'Weekly',
            ),
            Tab(
              text: 'Monthly',
            )
          ]),
        ),
        body: TabBarView(children: [
          dailySalesOverview(),
          weeklySalesOverview(),
          monthlySalesOverview()
        ]),
      ),
    );
  }
}

class dailySalesOverview extends StatefulWidget {
  const dailySalesOverview({super.key});

  @override
  State<dailySalesOverview> createState() => _dailySalesOverviewState();
}

class _dailySalesOverviewState extends State<dailySalesOverview> {
  late DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double ewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _dateController,
              onTap: _selectDate,
              readOnly: true,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                // color: Colors.blue, // Customize text color
              ),
              decoration: InputDecoration(
                hintText: 'Select Date',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey.shade100,
            width: ewidth * 0.94,
            padding: EdgeInsets.all(8),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up_sharp,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Sales Overview',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.blue,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's sales",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹2400',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '+4%',
                            style: TextStyle(color: Colors.green.shade600),
                          ),
                          Icon(
                            Icons.arrow_upward_outlined,
                            size: 15,
                            color: Colors.green.shade600,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Previous Thur',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '₹2300',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivered orders',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '15',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '-1%',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          Icon(Icons.arrow_downward,
                              size: 15, color: Colors.red.shade700)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Average order value',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹155',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '-1%',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          Icon(Icons.arrow_downward,
                              size: 15, color: Colors.red.shade700)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
          )
        ],
      ),
    ));
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      // Customize date picker appearance
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Customize primary color
            hintColor: Colors.blue, // Customize accent color
            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        updateDateControllerText(selectedDate);
      });
    }
  }

  void updateDateControllerText(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      // Selected date is today
      _dateController.text = 'Today - ${DateFormat('dd MMM').format(date)}';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      // Selected date is yesterday
      _dateController.text = 'Yesterday - ${DateFormat('dd MMM').format(date)}';
    } else {
      // Selected date is neither today nor yesterday
      _dateController.text = DateFormat('EEEE - dd MMM').format(date);
    }
  }
}

class weeklySalesOverview extends StatefulWidget {
  const weeklySalesOverview({super.key});

  @override
  State<weeklySalesOverview> createState() => _weeklySalesOverviewState();
}

class _weeklySalesOverviewState extends State<weeklySalesOverview> {
  @override
  Widget build(BuildContext context) {
    double ewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey.shade100,
            width: ewidth * 0.94,
            padding: EdgeInsets.all(8),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up_sharp,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Sales Overview',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.blue,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Weekly sales",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹24000',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '+4%',
                            style: TextStyle(color: Colors.green.shade600),
                          ),
                          Icon(
                            Icons.arrow_upward_outlined,
                            size: 15,
                            color: Colors.green.shade600,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Previous Week',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '₹23000',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivered orders',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '155',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '-1%',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          Icon(Icons.arrow_downward,
                              size: 15, color: Colors.red.shade700)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Average order value',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹155',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '-1%',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          Icon(Icons.arrow_downward,
                              size: 15, color: Colors.red.shade700)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
          )
        ],
      ),
    ));
  }
}

class monthlySalesOverview extends StatefulWidget {
  const monthlySalesOverview({super.key});

  @override
  State<monthlySalesOverview> createState() => _monthlySalesOverviewState();
}

class _monthlySalesOverviewState extends State<monthlySalesOverview> {
  @override
  Widget build(BuildContext context) {
    double ewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey.shade100,
            width: ewidth * 0.94,
            padding: EdgeInsets.all(8),
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up_sharp,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Sales Overview',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Details',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.blue,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Monthly sales",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹48000',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '+4%',
                            style: TextStyle(color: Colors.green.shade600),
                          ),
                          Icon(
                            Icons.arrow_upward_outlined,
                            size: 15,
                            color: Colors.green.shade600,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Previous Month',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '₹23000',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivered orders',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '155',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '-1%',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          Icon(Icons.arrow_downward,
                              size: 15, color: Colors.red.shade700)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Average order value',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹155',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '-1%',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                          Icon(Icons.arrow_downward,
                              size: 15, color: Colors.red.shade700)
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
          )
        ],
      ),
    ));
  }
}

class daysRangeSalesOverview extends StatefulWidget {
  const daysRangeSalesOverview({super.key});

  @override
  State<daysRangeSalesOverview> createState() => _daysRangeSalesOverviewState();
}

class _daysRangeSalesOverviewState extends State<daysRangeSalesOverview> {
  // late DateTime selectedDate = DateTime.now();
  DateTimeRange selectedDates =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  TextEditingController _daterangeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double ewidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Date Range"),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _daterangeController,
                  onTap: () {
                    selectDateRange();
                  },
                  readOnly: true,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.blue, // Customize text color
                  ),
                  decoration: InputDecoration(
                    hintText: 'Select Date',
                    prefixIcon: Icon(Icons.edit_calendar_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey.shade100,
                width: ewidth * 0.94,
                padding: EdgeInsets.all(8),
                child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up_sharp,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Sales Overview',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Details',
                                style: TextStyle(color: Colors.blue),
                              ),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                color: Colors.blue,
                                size: 15,
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's sales",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                '₹2400',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                '+4%',
                                style: TextStyle(color: Colors.green.shade600),
                              ),
                              Icon(
                                Icons.arrow_upward_outlined,
                                size: 15,
                                color: Colors.green.shade600,
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Previous Thur',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            '₹2300',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivered orders',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '15',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                '-1%',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              Icon(Icons.arrow_downward,
                                  size: 15, color: Colors.red.shade700)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Average order value',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '₹155',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                '-1%',
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                              Icon(Icons.arrow_downward,
                                  size: 15, color: Colors.red.shade700)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ]),
              )
            ],
          ),
        ));
  }

  Future<void> selectDateRange() async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(3000));
    if (dateTimeRange != null) {
      setState(() {
        selectedDates = dateTimeRange;
        updateDateRangeText(selectedDates);
      });
    }
  }

  // Function to update the text in the date range TextFormField
  // void updateDateRangeText(DateTimeRange dateRange) {
  //   _daterangeController.text =
  //       '${DateFormat.dMy().format(dateRange.start)} - ${DateFormat.yMd().format(dateRange.end)}';
  // }
  void updateDateRangeText(DateTimeRange dateRange) {
    _daterangeController.text =
        '${DateFormat.d().format(dateRange.start)} ${DateFormat.MMM().format(dateRange.start)} ${DateFormat.y().format(dateRange.start)} - ${DateFormat.d().format(dateRange.end)} ${DateFormat.MMM().format(dateRange.end)} ${DateFormat.y().format(dateRange.end)}';
  }
}

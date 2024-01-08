// import 'dart:html';

import 'package:e_commerce/apis/WeeklySales.dart';
import 'package:e_commerce/services/User_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'apis/CustomDateRangeSalesReport.dart';
import 'apis/DailySales.dart';
import 'apis/MonthlySales.dart';

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
   late OrderSummaryDaily data ;
  late DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
bool ok = false;
  Future<void> fetchData() async{
    data = await UserApi.GetDailySales();
    setState(() {
ok=true;
    });
  }


  @override
  void initState() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool plus =false,minus=false,zero=false;
    if(ok)
    {
      String yourString = data.percentChangeInAmount.toString();

      // Check if the string starts with +, -, or 0
      plus= yourString.startsWith('+') ;
      minus =    yourString.startsWith('-');

      zero =     yourString.startsWith('0');
    }bool plus1 =false,minus1=false,zero1=false;
    if(ok)
    {
      String yourString = data.percentChangeInDeliveredOrders.toString();

      // Check if the string starts with +, -, or 0
      plus1= yourString.startsWith('+') ;
      minus1 =    yourString.startsWith('-');

      zero =     yourString.startsWith('0');
    }bool plus2 =false,minus2=false,zero2=false;
    if(ok)
    {
      String yourString = data.percentChangeInAvgOrdervalue.toString();

      // Check if the string starts with +, -, or 0
      plus2= yourString.startsWith('+') ;
      minus2 =    yourString.startsWith('-');

      zero2 =     yourString.startsWith('0');
    }
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
          (ok)?Container(
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
                            '₹${data?.todaysOrder[0].totalAmount}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInAmount}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Previous Day',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        '₹${data?.yesterdayOrders[0].totalAmount}',
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
                            ' ${data.todaysOrder[0].deliveredOrders}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInDeliveredOrders}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus1) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus1) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
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
                        'Average order value',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹${data.todaysOrder[0].avgOrderValue}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInAvgOrdervalue}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus2) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus2) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
          ):Center(child: CircularProgressIndicator(),)
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

  late OrderSummaryWeekly data ;
  bool ok = false;
  Future<void> fetchData() async{
     data = await UserApi.GetWeeklySales();
     print(data);
     setState(() {
        ok=true;
     });
  }

  @override
  void initState() {
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    bool plus =false,minus=false,zero=false;
    if(ok)
    {
      String yourString = data.percentChangeInAmount.toString();

      // Check if the string starts with +, -, or 0
      plus= yourString.startsWith('+') ;
      minus =    yourString.startsWith('-');

      zero =     yourString.startsWith('0');
    }
    bool plus1 =false,minus1=false,zero1=false;
    if(ok)
    {
      String yourString = data.percentChangeInDeliveredOrders.toString();

      // Check if the string starts with +, -, or 0
      plus1= yourString.startsWith('+') ;
      minus1 =    yourString.startsWith('-');

      zero =     yourString.startsWith('0');
    }
    bool plus2 =false,minus2=false,zero2=false;
    if(ok)
    {
      String yourString = data.percentChangeInAvgOrdervalue.toString();

      // Check if the string starts with +, -, or 0
      plus2= yourString.startsWith('+') ;
      minus2 =    yourString.startsWith('-');

      zero2 =     yourString.startsWith('0');
    }
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
          (ok)? Container(
            color: Colors.grey.shade100,
            width: ewidth * 0.94,
            padding: EdgeInsets.all(8),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  const Row(
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
                            '₹${data?.todaysOrder[0].totalAmount}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInAmount}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.black),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
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
                        '₹${data?.yesterdayOrders[0].totalAmount}',
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
                            ' ${data?.todaysOrder[0].deliveredOrders}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInDeliveredOrders}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus1) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus1) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
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
                        'Average order value',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹${data?.todaysOrder[0].avgOrderValue}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInAvgOrdervalue}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus2) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus2) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
          ) : Center(child: CircularProgressIndicator(),)
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

  late OrderSummaryMonthly data ;
bool ok = false;
  Future<void > fetchData() async {
    data = await UserApi.GetMonthlySales();
    setState(() {
ok=true;
    });
  }

  @override
  void initState() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool plus =false,minus=false,zero=false;
    if(ok)
    {
      String yourString = data.percentChangeInAmount.toString();

      // Check if the string starts with +, -, or 0
      plus= yourString.startsWith('+') ;
      minus =    yourString.startsWith('-');

      zero =     yourString.startsWith('0');
    }bool plus1 =false,minus1=false,zero1=false;
    if(ok)
    {
      String yourString = data.percentChangeInDeliveredOrders.toString();

      // Check if the string starts with +, -, or 0
      plus1= yourString.startsWith('+') ;
      minus1 =    yourString.startsWith('-');

      zero =     yourString.startsWith('0');
    }bool plus2 =false,minus2=false,zero2=false;
    if(ok)
    {
      String yourString = data.percentChangeInAvgOrdervalue.toString();

      // Check if the string starts with +, -, or 0
      plus2= yourString.startsWith('+') ;
      minus2 =    yourString.startsWith('-');

      zero2 =     yourString.startsWith('0');
    }

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
          (ok) ? Container(
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
                            '₹${data.todaysOrder[0].totalAmount}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInAmount}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
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
                            ' ${data.todaysOrder[0].deliveredOrders}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInDeliveredOrders}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus1) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus1) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
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
                        'Average order value',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹${data.todaysOrder[0].avgOrderValue}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            '${data.percentChangeInAvgOrdervalue}%',
                            style: TextStyle(
                              color: plus ? Colors.green.shade700 : (minus ? Colors.red.shade700 : Colors.green.shade700),
                            ),
                          ),
                          Column(
                            children: [
                              if (plus1) ...[
                                Icon(
                                  Icons.arrow_upward,
                                  size: 15,
                                  color: Colors.green.shade700,
                                ),
                              ] else if (minus1) ...[
                                Icon(
                                  Icons.arrow_downward,
                                  size: 15,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ]),
          ): Center(child: CircularProgressIndicator(),)
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
  late TotalOrder data ;

  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  TextEditingController _daterangeController = TextEditingController();
  bool ok = false;

  Future<void> fetchData() async {
    // Format the start and end dates to "yyyy-MM-dd" format
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(selectedDates.start);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(selectedDates.end);
  print("formattedStartDate");
  print(formattedStartDate);
    data = await UserApi.GetCustomSales(formattedStartDate, formattedEndDate);

    setState(() {
      ok = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
              (ok) ? Container(
                color: Colors.grey.shade100,
                width: ewidth * 0.94,
                padding: EdgeInsets.all(8),
                child:  Column(
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
                            'Total Orders',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${data.totalOrders[0].totalOrders.toString()}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 7,
                              ),

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
                      ), Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '₹${data.totalOrders[0].totalAmount}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 7,
                              ),

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
                                '₹${data.totalOrders[0].avgOrderValue}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 7,
                              ),

                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ]),
              ) : Center(child: CircularProgressIndicator(),)
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
        fetchData();
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

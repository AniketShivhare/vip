import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool isGetCurrentLocation = false;

class GetUserCurrentLocationScreen extends StatefulWidget {
  final Function updateParentState;
  const GetUserCurrentLocationScreen(
      {super.key, required this.updateParentState});

  @override
  State<GetUserCurrentLocationScreen> createState() =>
      _GetUserCurrentLocationScreenState();
}

bool _isopen = false;

class _GetUserCurrentLocationScreenState
    extends State<GetUserCurrentLocationScreen> {
  bool _isPermissionGranted = false;

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.593683, 78.962883),
    zoom: 4.5,
  );

  final List<Marker> _markers = <Marker>[
    // Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(20.593683, 78.962883),
    //     infoWindow: InfoWindow(
    //       title: 'The title of the marker'
    //     )
    // )
  ];

  loadData() {
    getUserCurrentLocation().then((value) async {
      print('my current location');
      print(value.latitude.toString() + " " + value.longitude.toString());

      _markers.add(Marker(
          markerId: MarkerId('2'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: 'My Current Location')));

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 16);

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  // Future<Position> getUserCurrentLocation() async{
  //
  //   await Geolocator.requestPermission().then((value){
  //
  //   }).onError((error, stackTrace) {
  //     print("error"+error.toString());
  //
  //       await showDialog(context: context, builder:(context) =>LocationPermissionDialog(),);
  //       await getUserCurrentLocation();
  //   });
  //
  //   return await Geolocator.getCurrentPosition();
  // }

  Future<Position> getUserCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      // _isPermissionGranted = true;
      // return await Geolocator.getCurrentPosition();

      LocationPermission status = await Geolocator.checkPermission();

      if (status == LocationPermission.always ||
          status == LocationPermission.whileInUse) {
        // Permission granted, get the current position

        _isPermissionGranted = true;

        return await Geolocator.getCurrentPosition();
      } else if (status == LocationPermission.denied) {
        // Permission denied
        print('Location permission denied by user.');

        throw Exception('Location permission denied by user.');
      } else {
        throw Exception('Location permission status: $status');
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => LocationPermissionDialog(),
      );
      // print(_isopen);
      if (_isopen == false) return await getUserCurrentLocation();
      // print('Error getting location: $e');
      //
      throw Exception('Error getting location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          zoomControlsEnabled: false,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),

      floatingActionButton: _isPermissionGranted
          ? Container(
              width: 100,
              height: 45,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  isGetCurrentLocation = true;
                  widget.updateParentState();
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          : SizedBox.shrink(), // Hide the FAB if permission is not granted
    );
  }
}

class LocationPermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location Permission Required'),
      content: Text(
        'To access this feature, we need your permission to use your device\'s location. Please grant the location permission to continue.',
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            _isopen = true;
            Navigator.pop(context);
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _isopen = false;
            Navigator.pop(context);
          },
          child: Text('Grant Permission'),
        ),
      ],
    );
  }
}

import 'dart:ui';

import 'package:e_commerce/services/User_api.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'Regestration.dart';

class dropDown extends StatefulWidget {
  final bool initialValue;
  final Function(bool) updateInitialValue;
  final String token, id;
  const dropDown({
    Key? key,
    required this.initialValue,
    required this.updateInitialValue,
    required this.token,
    required this.id,
  }) : super(key: key);

  @override
  State<dropDown> createState() => _dropDownState();
}

bool isSelectStoreType = false;
bool isSelectStoreCategory = false;
bool isFoodSelectAsStoreCategory = false;
bool isPureVegFilled = false;

class _dropDownState extends State<dropDown> {
  List<String> StoreCategory = [
    'Grocery & Essentials',
    'Fruits & Vegetables',
    'Personal Care',
    'Dairy Products',
    'Food, Snacks & Sweets',
    'Bakery & Namkeen',
    'Electricals & Electronics',
    'Books & Stationery',
    'Gifts & Toys',
    'Art & Decoration',
    'Home & Office',
    'Pharma',
    'Wellness & Fitness',
    'Pet Care',
    'Sanitary & Hardware',
    'Fashion',
    'Others'
  ];
  List<String> selectedStoreCategory = [];

  Future<void> saveStoreCategory() async {
    print(selectedStoreCategory);
    print("selectedStoreCategory");
    if (selectedStoreCategory.isNotEmpty) {
      isSelectStoreCategory = true;
    } else {
      isSelectStoreCategory = false;
    }
    Map<String, dynamic> updatedFields = {
      "shopCategoryDetails": {"category": selectedStoreCategory}
    };
    await UserApi.updateSeller(widget.token, widget.id, updatedFields);
  }

  @override
  Widget build(BuildContext context) {
    // var isFood=
    return Column(
      children: [
        // Text(''),

        Container(
          width: 400,
          child: DropDownMultiSelect(
            options: StoreCategory,
            selectedValues: selectedStoreCategory,
            onChanged: (value) {
              print('selected Store Category $value');
              setState(() {
                selectedStoreCategory = value;
                saveStoreCategory();
              });
              String searchString = 'Food, Snacks & Sweets';
              print(
                  'you have selected $selectedStoreCategory Store Categories.');
              if (selectedStoreCategory.contains(searchString)) {
                // foodInformation();

                setState(() {
                  food_present = true;
                  // isFoodSelectAsStoreCategory = true;
                });
                widget.updateInitialValue(food_present);
                print(food_present);
                print("food_present");
              } else {
                setState(() {
                  food_present = false;
                  // isFoodSelectAsStoreCategory = true;
                });
                widget.updateInitialValue(food_present);
                // print('$searchString not found in the list.');
              }
            },
            whenEmpty: 'Select Store Category',
          ),
        ),
      ],
    );
  }
}

class dropDown2 extends StatefulWidget {
  final Function updateParentSelectStoreType;
  const dropDown2({required this.updateParentSelectStoreType, Key? key})
      : super(key: key);

  @override
  State<dropDown2> createState() => _dropDown2State();
}

class _dropDown2State extends State<dropDown2> {
  List<String> StoreType = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
    "Item 7",
    "Item 8",
    "Item 9",
    "Item 10"
  ];
  List<String> selectedStoreType = [];
  Future<void> saveStoreType() async {
    if (selectedStoreType.isNotEmpty) {
      isSelectStoreType = true;
      widget.updateParentSelectStoreType();
    } else {
      isSelectStoreType = false;
      widget.updateParentSelectStoreType();
    }

    Map<String, dynamic> updatedFields = {
      "shopCategoryDetails": {"storeType": selectedStoreType}
    };
    await UserApi.updateSeller(TokenId.token, TokenId.id, updatedFields);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400,
          child: DropDownMultiSelect(
            options: StoreType,
            selectedValues: selectedStoreType,
            onChanged: (value) {
              print('selected Store type $value');
              setState(() {
                selectedStoreType = value;
                saveStoreType();
              });
              print('you have selected $selectedStoreType Store Types.');
            },
            whenEmpty: 'Select Store Type',
          ),
        ),
      ],
    );
  }
}

class foodInformation extends StatefulWidget {
  final Function updateParentFoodPresent;
  const foodInformation({required this.updateParentFoodPresent, Key? key});

  @override
  State<foodInformation> createState() => _foodInformationState();
}

class _foodInformationState extends State<foodInformation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              cuisines(updateParentFoodPresent: widget.updateParentFoodPresent),
        ),
        (!isFoodSelectAsStoreCategory && isNexttap)
            ? Text(
                'Please Select Cuisines Type.',
                style: TextStyle(
                    color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
              )
            : Text(''),
        SizedBox(
          height: 20,
        ),
        Container(
          child: RadioExample(
              updateParentFoodPresent: widget.updateParentFoodPresent),
        ),
        (!isPureVegFilled && isNexttap)
            ? Text(
                'Please Select Your shop pure veg.',
                style: TextStyle(
                    color: Color.fromRGBO(183, 21, 9, 1), fontSize: 12),
              )
            : Text(''),
      ],
    );
  }
}

class cuisines extends StatefulWidget {
  final Function updateParentFoodPresent;
  const cuisines({required this.updateParentFoodPresent, Key? key})
      : super(key: key);

  @override
  State<cuisines> createState() => _cuisinesState();
}

class _cuisinesState extends State<cuisines> {
  List<String> cuisinesType = [
    'Bengali',
    'Bihari',
    'Biryani',
    'Breakfast',
    'British',
    'Burger',
    'Cafe Food',
    'Cafeteria',
    'Cake',
    'Chili',
    'Chinese',
    'Continental',
    'Desserts',
    'European Food',
    'Fast Food',
    'French',
    'Fusion',
    'Gourmet Fast Food',
    'Grill House',
    'Gujarati',
    'Home-made',
    'Hyderabadi',
    'Indian',
    'Italian',
    'Japanese',
    'Juices',
    'Kashmiri',
    'Kerala',
    'Lucknowi',
    'Mexican',
    'Maharashtrian',
    'Mithai',
    'Multi Cuisine',
    'North Indian',
    'Pacific',
    'Pasta',
    'Pastry',
    'Pizza',
    'Rajasthani',
    'Russian',
    'Salad',
    'Seafood',
    'Shake',
    'Snacks',
    'South Indian',
    'Turkish',
    'Uzbek',
    'Vegan',
    'Vegetarian',
    'World Cuisine',
    'Wraps',
    'Others'
  ];
  List<String> selectedCuisinesType = [];

  Future<void> saveStoreCategory() async {
    if (selectedCuisinesType.isNotEmpty) {
      isFoodSelectAsStoreCategory = true;
      widget.updateParentFoodPresent();
      print('me bhara hu');
    } else {
      isFoodSelectAsStoreCategory = false;
      widget.updateParentFoodPresent();
      print('me khali hu');
    }
    Map<String, dynamic> updatedFields = {
      "shopCategoryDetails": {"cusinesOffered": selectedCuisinesType}
    };
    await UserApi.updateSeller(TokenId.token, TokenId.id, updatedFields);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 400,
          child: DropDownMultiSelect(
            options: cuisinesType,
            selectedValues: selectedCuisinesType,
            onChanged: (value) {
              print('selected Cuisine type $value');
              setState(() {
                selectedCuisinesType = value;
              });
              print('you have selected $selectedCuisinesType Cuisine Types.');
              saveStoreCategory();
            },
            whenEmpty: 'Select Cuisines Type',
          ),
        ),
      ],
    );
  }
}

class RadioExample extends StatefulWidget {
  final Function updateParentFoodPresent;
  RadioExample({required this.updateParentFoodPresent});
  @override
  _RadioExampleState createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  bool? _isYes;
  Future<void> saveStoreCategory() async {
    Map<String, dynamic> updatedFields;

    if (_isYes == true) {
      isPureVegFilled = true;
      updatedFields = {
        "shopCategoryDetails": {"isPureVeg": "true"}
      };
      widget.updateParentFoodPresent();
    } else if (_isYes == false) {
      isPureVegFilled = true;
      updatedFields = {
        "shopCategoryDetails": {"isPureVeg": "false"}
      };
      widget.updateParentFoodPresent();
    } else {
      isPureVegFilled = false;
      updatedFields = {
        "shopCategoryDetails": {"isPureVeg": "false"}
      };
      widget.updateParentFoodPresent();
    }

    await UserApi.updateSeller(TokenId.token, TokenId.id, updatedFields);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            ' Is Your Shop Pure Veg?',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: const Text('Yes'),
          leading: Radio(
            value: true,
            groupValue: _isYes,
            onChanged: (bool? value) {
              setState(() {
                _isYes = value;
                saveStoreCategory();
              });
            },
          ),
        ),
        ListTile(
          title: const Text('No'),
          leading: Radio(
            value: false,
            groupValue: _isYes,
            onChanged: (bool? value) {
              setState(() {
                _isYes = value;
                saveStoreCategory();
              });
            },
          ),
        ),
        // SizedBox(height: 20.0),
        // _isYes != null
        //     ? Text(_isYes == true ? 'You selected: Yes' : 'You selected: No')
        //     : Container(),
      ],
    );
  }
}

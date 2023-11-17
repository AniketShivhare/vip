import 'dart:async';

import 'package:e_commerce/services/Categories.dart';
import 'package:e_commerce/services/filterData.dart';
import 'package:e_commerce/services/tokenId.dart';
import 'package:flutter/material.dart';
import 'googleFonts.dart';
import 'main_dashboard.dart';
void main() {
  runApp(MyApp());
}

bool ok=false;
double _minPrice = 0;
double _maxPrice = 100;
TextEditingController _minPriceController = TextEditingController();
TextEditingController _maxPriceController = TextEditingController();
String selectedDiscountOption = 'Any Discount';
String selectedRatingOption = 'Any Rating';
bool priceChanged=false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilterScreen(),
    );
  }
}


class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int selectedCategoryIndex = -1;
  int selectedButtonIndex = 0;
  List<String> selectedCategories = [];
  Map<String, List<String>> selectedSubcategories = {};
  FilterOptions selectedFilters = FilterOptions();


  List<String> categories = Categories.categories;
  List<String> images = Categories.images;
  Map<String, List<String>> subcategories = {};

  List<String> filters = [
    "Category",
    "Sub-category",
    "Ratings",
    "Discount Range",
  ];

  void onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  void onResetFilters() {
    setState(() {
      selectedCategories.clear();
      selectedSubcategories.clear();
      _minPrice = 0;
      _maxPrice = 100;
      _minPriceController.text = '0';
      _maxPriceController.text = '100';

    });
  }

  void onApplyFilters() {
    FilterOptions.categories = selectedCategories;
    FilterOptions.subcategories = selectedSubcategories;
    FilterOptions.minPrice = _minPrice;
    FilterOptions.maxPrice = _maxPrice;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainDashboard(token: TokenId.token, id: TokenId.id, pageIndex: 0,sortt:""),
      ),
          // This line clears the navigator stack
    );
  }


  Widget buildCategoryScreen() {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var isSelected = selectedCategories.contains(categories[index]);

          return GestureDetector(
            onTap: () async {
              setState(()  {
                if (isSelected) {
                  selectedCategories.clear();
                  FilterOptions.changed=false;
                  ok=false;
                } else {
                  selectedCategories = [categories[index]];
                  FilterOptions.changed=true;
                  ok=true;
                }
              });
              await Categories.getSubCategories(categories[index]) ;
              List<String> subCat = Categories.subCategories;
              subcategories[selectedCategories[0]] = subCat;
            },
            child: Container(
              padding: EdgeInsets.all(15),
              color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image
                  //     .network(images[index]),
                  Expanded(
                    child: Text(
                      categories[index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Radio<bool>(
                    value: isSelected,
                    groupValue: true,
                    onChanged: null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSubcategoryScreen() {
    if(selectedCategories.length==0) {
      return const Center(
        child: Text('Select Category First'),
      );
    }
    return ok
        ? FutureBuilder<void>(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, categoryIndex) {
                  final category = selectedCategories[categoryIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      Text(category),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: subcategories[category]!.length,
                        itemBuilder: (context, subcategoryIndex) {
                          final subcategory = subcategories[category]![subcategoryIndex];
                          final isSelected = selectedSubcategories[category]?.contains(subcategory) ?? false;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subcategory,
                                  maxLines: 2, // Display text in up to 2 lines
                                  overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected != null) {
                                      if (selected) {
                                        if (selectedSubcategories[category] == null) {
                                          FilterOptions.selectedSubCat=false;
                                          selectedSubcategories[category] = [];
                                        } else {
                                          FilterOptions.selectedSubCat=true;
                                        }
                                        selectedSubcategories[category]!.add(subcategory);

                                      } else {
                                        selectedSubcategories[category]?.remove(subcategory);
                                      }
                                    }
                                  });

                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
          );
        } else {
          ok=false;
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
        : Container(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, categoryIndex) {
          final category = selectedCategories[categoryIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12,),
              Text(category),
              ListView.builder(
                shrinkWrap: true,
                itemCount: subcategories[category]!.length,
                itemBuilder: (context, subcategoryIndex) {
                  final subcategory = subcategories[category]![subcategoryIndex];
                  final isSelected = selectedSubcategories[category]?.contains(subcategory) ?? false;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          subcategory,
                          maxLines: 2, // Display text in up to 2 lines
                          overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                        ),
                      ),
                      Checkbox(
                        value: isSelected,
                        onChanged: (selected) {
                          setState(() {
                            if (selected != null) {
                              if (selected) {
                                if (selectedSubcategories[category] == null) {
                                  FilterOptions.selectedSubCat=false;
                                  selectedSubcategories[category] = [];
                                } else {
                                  FilterOptions.selectedSubCat=true;
                                }
                                selectedSubcategories[category]!.add(subcategory);

                              } else {
                                selectedSubcategories[category]?.remove(subcategory);
                              }
                            }
                          });

                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }








  Widget buildRatingsScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('Ratings', style: headingSmallStyle),
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
        ),
        SizedBox(height: 12),
        ListTile(
          title: Text('Any Rating'),
          leading: Radio<String>(
            value: 'Any Rating',
            groupValue: selectedRatingOption,
            onChanged: (value) {
              setState(() {
                selectedRatingOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('4.5 or above'),
          leading: Radio<String>(
            value: '4.5 or above',
            groupValue: selectedRatingOption,
            onChanged: (value) {
              setState(() {
                selectedRatingOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('4 or above'),
          leading: Radio<String>(
            value: '4 or above',
            groupValue: selectedRatingOption,
            onChanged: (value) {
              setState(() {
                selectedRatingOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('3.5 or above'),
          leading: Radio<String>(
            value: '3.5 or above',
            groupValue: selectedRatingOption,
            onChanged: (value) {
              setState(() {
                selectedRatingOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('3 or above'),
          leading: Radio<String>(
            value: '3 or above',
            groupValue: selectedRatingOption,
            onChanged: (value) {
              setState(() {
                selectedRatingOption = value!;
              });
            },
          ),
        ),

        SizedBox(height: 16),
        Text('Selected Rating: $selectedRatingOption', style: captionStyle),
      ],
    );
  }

  Widget buildDiscountScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('Discount', style: headingSmallStyle),
          alignment: Alignment.center,
          padding: EdgeInsets.all(12),
        ),
        SizedBox(height: 12),
        // Create radio buttons for discount options
        ListTile(
          title: Text('Any Discount'),
          leading: Radio<String>(
            value: 'Any Discount',
            groupValue: selectedDiscountOption,
            onChanged: (value) {
              setState(() {
                selectedDiscountOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('10% or more'),
          leading: Radio<String>(
            value: '10% or more',
            groupValue: selectedDiscountOption,
            onChanged: (value) {
              setState(() {
                selectedDiscountOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('20% or more'),
          leading: Radio<String>(
            value: '20% or more',
            groupValue: selectedDiscountOption,
            onChanged: (value) {
              setState(() {
                selectedDiscountOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('30% or more'),
          leading: Radio<String>(
            value: '20% or more',
            groupValue: selectedDiscountOption,
            onChanged: (value) {
              setState(() {
                selectedDiscountOption = value!;
              });
            },
          ),
        ),
        ListTile(
          title: Text('40% or more'),
          leading: Radio<String>(
            value: '20% or more',
            groupValue: selectedDiscountOption,
            onChanged: (value) {
              setState(() {
                selectedDiscountOption = value!;
              });
            },
          ),
        ),
        SizedBox(height: 16),
        Text('Selected Discount: $selectedDiscountOption', style: captionStyle),
      ],
    );
  }



  Widget buildFilterScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return buildCategoryScreen();
      case 1:
        return  buildSubcategoryScreen();
      case 3:
        return buildRatingsScreen();
      case 4:
        return buildDiscountScreen();
      default:
        return Center(
          child: Text("Content for ${filters[selectedIndex]}"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Screen',style: headingMediumStyle,),
        actions: [
          TextButton(
            onPressed: (){
              onResetFilters();
            },
            child: Text('Reset',style: headingSmallStyle,),
          ),
          TextButton(
            onPressed: (){
              onApplyFilters();
            },
            child: Text('Apply',style: headingSmallStyle,),
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Column - Buttons
          Container(
            width: 150,
            child: ListView.builder(
              itemCount: filters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedButtonIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: index == selectedButtonIndex ? Colors.blue.withOpacity(0.5) : Colors.white,
                    child: Text(filters[index]),
                  ),
                );
              },
            ),
          ),
          // Right Column - Windows
          Expanded(
            child: buildFilterScreen(selectedButtonIndex),
          ),
        ],
      ),
    );
  }
}





void showCategoryScreen(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {

      return FilterScreen();
    },
  );
}


class SizeChips extends StatefulWidget {
  @override
  _SizeChipsState createState() => _SizeChipsState();
}

class _SizeChipsState extends State<SizeChips> {
  List<String> selectedSizes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12,),
            Text('Size',style: headingSmallStyle,),
            SizedBox(height: 18,),
            Wrap(
              spacing: 8,
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('S'),
                    selected: selectedSizes.contains('S'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSizes.add('S');
                        } else {
                          selectedSizes.remove('S');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('M'),
                    selected: selectedSizes.contains('M'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSizes.add('M');
                        } else {
                          selectedSizes.remove('M');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('L'),
                    selected: selectedSizes.contains('L'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSizes.add('L');
                        } else {
                          selectedSizes.remove('L');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('XL'),
                    selected: selectedSizes.contains('XL'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSizes.add('XL');
                        } else {
                          selectedSizes.remove('XL');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('XXL'),
                    selected: selectedSizes.contains('XXL'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedSizes.add('XXL');
                        } else {
                          selectedSizes.remove('XXL');
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Selected Sizes: ${selectedSizes.join(", ")}',style: captionStyle,)
          ],
        ),
      ),
    );
  }
}



class BrandsChips extends StatefulWidget {
  @override
  _BrandsChipsState createState() => _BrandsChipsState();
}

class _BrandsChipsState extends State<BrandsChips> {
  List<String> selectedBrands = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 12,),
          Text('Size',style: headingSmallStyle,),
          SizedBox(height: 18,),
          Padding(padding: EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('S'),
                    selected: selectedBrands.contains('S'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedBrands.add('S');
                        } else {
                          selectedBrands.remove('S');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('M'),
                    selected: selectedBrands.contains('M'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedBrands.add('M');
                        } else {
                          selectedBrands.remove('M');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('L'),
                    selected: selectedBrands.contains('L'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedBrands.add('L');
                        } else {
                          selectedBrands.remove('L');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('XL'),
                    selected: selectedBrands.contains('XL'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedBrands.add('XL');
                        } else {
                          selectedBrands.remove('XL');
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child:  FilterChip(
                    label: Text('XXL'),
                    selected: selectedBrands.contains('XXL'),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedBrands.add('XXL');
                        } else {
                          selectedBrands.remove('XXL');
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text('Selected Sizes: ${selectedBrands.join(", ")}',style: captionStyle,)
        ],
      ),
    );
  }
}
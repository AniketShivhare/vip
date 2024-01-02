
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../apis/ProductModel.dart';

class StockUpdateDialog extends StatefulWidget {
  final Product prod;
  final callSetState;

  StockUpdateDialog({required this.prod, required  this.callSetState});

  @override
  _StockUpdateDialogState createState() => _StockUpdateDialogState();
}

class _StockUpdateDialogState extends State<StockUpdateDialog> {


  bool isChanged = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        height: min(450,widget.prod.productDetails.length*105+95),
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 0.9,
                  child: CupertinoSwitch(
                    activeColor: Colors.green,
                    value: widget.prod.inStock,
                    onChanged: (bool value) {
                      isChanged=true;
                      setState(() {
                        widget.prod.inStock = value;
                      });
                    },
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Make all variants out of Stock',
                    style: TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.prod.productDetails.length,
                itemBuilder: (context, index) {
                  QuantityPricing pricing = widget.prod.productDetails[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Quantity: ${widget.prod.productDetails[index].quantity}${widget.prod.productDetails[index].unit}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('MRP Price: ${widget.prod.productDetails[index].mrpPrice}'),
                                Spacer(),
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    activeColor: Colors.green,
                                    value: pricing.inStock,
                                    onChanged: (bool value) {
                                      isChanged=true;
                                      setState(() {
                                        widget.prod.productDetails[index].inStock = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text('Offer Price: ${widget.prod.productDetails[index].offerPrice}'),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
            if(isChanged==true)
              Center(
                child: ElevatedButton(onPressed: (){
                  postPersonalDetails(widget.prod.productDetails);
                  widget.callSetState();
                  Navigator.pop(context);
                },
                    child: Text('Save Changes')),
              ),
          ],
        ),
      ),
    );
  }


  Future<bool> _onWillPop() async {
    if (isChanged) {
      return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Unsaved Changes'),
            content: Text('You have unsaved changes. Do you want to save them?'),
            actions: <Widget>[
              TextButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Discard changes and go back
                },
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  postPersonalDetails(widget.prod.productDetails);
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ) ?? false;
    }
     return true;
  }
  Future<void> postPersonalDetails (productDetails) async{

  }

}

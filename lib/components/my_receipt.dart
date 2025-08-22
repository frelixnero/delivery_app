import 'package:delivery_app/models/resturant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReceipt extends StatelessWidget {
  final String receiptHeader;
  final String? fontFamily;
  MyReceipt({super.key, required this.receiptHeader, required this.fontFamily});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              receiptHeader,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w200,
              ),
            ),

            SizedBox(height: 20),

            //
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Consumer<Resturant>(
                builder:
                    (context, resturant, child) => Text(
                      resturant.displayCartReceipt(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontFamily: "Typewriter",
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

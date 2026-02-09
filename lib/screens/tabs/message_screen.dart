import 'package:flutter/material.dart';
import 'package:tutam_fit/constants/app_colors.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        title: Title(
          color: AppColors.deepNavy,
          child: Center(
            child: Text(
              'Messaging Center',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      // BODY
      body: Container(
        color: AppColors.limeGreen,
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                SizedBox(width: 10,),
                Text('Order Updates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                SizedBox(width: 90,),
                Icon(Icons.arrow_right,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

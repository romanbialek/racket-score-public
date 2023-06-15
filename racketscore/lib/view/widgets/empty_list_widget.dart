import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String message;

  const EmptyListWidget({Key? key, this.message = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}






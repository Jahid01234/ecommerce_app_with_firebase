
import 'package:flutter/material.dart';


void displayMessageToUser(String message, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,// margin use for
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          content: Text(message)
      )
  );
}
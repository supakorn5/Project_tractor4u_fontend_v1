import 'package:flutter/material.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  ProfileWidget(
      {super.key,
      required this.title,
      required this.onPress,
      this.endIcon = true,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(4, 5), blurRadius: 3)
        ],
        color: Color.fromARGB(a, r, g, b).withOpacity(1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        title: Text(
          "${title}",
          style: TextStyle(fontFamily: "Prompt", color: textColor),
        ),
        trailing: endIcon
            ? GestureDetector(
                onTap: onPress,
                child: Container(
                  height: 50,
                  child: Icon(
                    LineAwesomeIcons.edit,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

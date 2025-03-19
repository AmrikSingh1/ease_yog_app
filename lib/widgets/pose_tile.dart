import 'package:flutter/material.dart';
import '../models/pose.dart';
import '../screens/pose_detail_screen.dart';

class PoseTile extends StatelessWidget {
  final Pose pose;

  PoseTile({required this.pose});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(pose.name),
        subtitle: Text(pose.description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoseDetailScreen(pose: pose),
            ),
          );
        },
      ),
    );
  }
}

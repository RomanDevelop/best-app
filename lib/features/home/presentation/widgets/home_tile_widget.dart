import 'package:flutter/material.dart';
import '../../data/models/home_model.dart';

class HomeTileWidget extends StatelessWidget {
  final HomeModel item;

  const HomeTileWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(item.description),
    );
  }
}

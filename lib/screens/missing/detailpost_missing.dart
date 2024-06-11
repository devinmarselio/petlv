import 'package:flutter/material.dart';

class DetailMissing extends StatefulWidget {
  const DetailMissing({super.key});

  @override
  State<DetailMissing> createState() => _DetailMissingState();
}

class _DetailMissingState extends State<DetailMissing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Missing'),),
    );
  }
}

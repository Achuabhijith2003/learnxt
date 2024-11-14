import 'package:flutter/material.dart';

class Vip extends StatefulWidget {
  const Vip({super.key});

  @override
  State<Vip> createState() => _VipState();
}

class _VipState extends State<Vip> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Comming Soon"),
      ),
    );
  }
}

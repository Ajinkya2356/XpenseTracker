import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Xpense',
        showLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Text('Home Page Content'),
        ),
      ),
    );
  }
}

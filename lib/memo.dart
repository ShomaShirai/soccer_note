import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageC extends StatelessWidget {
  const PageC({super.key});

  pushForward(BuildContext context) {
    context.go('/a');
  }

  pushBackward(BuildContext context) {
    context.go('/b');
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          title: const Text('Page C'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => pushForward(context),
                child: const Text('Go to Page A'),
              ),
              ElevatedButton(
                onPressed: () => pushBackward(context),
                child: const Text('Go to Page B'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/firebase_options.dart'; // Import the generated Firebase options

class HelloWorld extends StatefulWidget {
  @override
  _HelloWorldState createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  late Future<FirebaseApp> _initialization;
  bool _nodeUpdated = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    // Initialize Firebase
    _initialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> _updateHelloWorldNode() async {
    try {
      final databaseRef = FirebaseDatabase.instance.ref().child('hello/world');

      // Delete all nodes under 'world'
      await databaseRef.remove();

      // Wait a short moment to ensure removal is processed
      await Future.delayed(Duration(seconds: 1));

      // Create a new value at 'hello/world'
      await databaseRef.set({
        'message': 'new hello world2',
      });

      setState(() {
        _nodeUpdated = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating node: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Display initialization error
          return Scaffold(
            appBar: AppBar(
              title: Text('Firebase Initialization Error'),
            ),
            body: Center(
              child: Text('Error initializing Firebase: ${snapshot.error}'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Call the method to update the node
          if (!_nodeUpdated) {
            _updateHelloWorldNode();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Firebase Initialized'),
            ),
            body: Center(
              child: _nodeUpdated
                  ? Text('Node updated with new value.')
                  : Text(_errorMessage.isEmpty
                      ? 'Updating node...'
                      : _errorMessage),
            ),
          );
        }

        // While initializing, show a progress indicator
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HelloWorld(),
  ));
}

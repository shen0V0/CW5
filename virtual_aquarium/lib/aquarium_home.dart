import 'package:flutter/material.dart';
import 'dart:async';
import 'fish.dart';
import 'DatabaseHelper.dart';

class AquariumHome extends StatefulWidget {
  @override
  _AquariumHomeState createState() => _AquariumHomeState();
}

class _AquariumHomeState extends State<AquariumHome> with SingleTickerProviderStateMixin {
  final List<Fish> _fishList = [];
  double _fishSpeed = 2.0;
  Color _fishColor = Colors.blue;
  AnimationController? _controller;
  final int _maxFish = 10;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSettings(); 
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _controller?.addListener(_updateFishPositions);
  }

  Future<void> _loadSettings() async {
    final fishList = await dbHelper.getFishList();
    setState(() {
      _fishList.clear();
      _fishList.addAll(fishList); 
    });
    print("Loaded fish: ${_fishList.length}");
  }

  void _addFish() {
    if (_fishList.length < _maxFish) {
      setState(() {
        final newFish = Fish(color: _fishColor, speed: _fishSpeed);
        _fishList.add(newFish);
        dbHelper.insertFish(newFish);  
      });
    }
  }

  void _removeFish() {
    if (_fishList.isNotEmpty) {
      setState(() {
        final removedFish = _fishList.removeLast();
        dbHelper.deleteFish(removedFish.id!);  
      });
    }
  }

  void _updateFishPositions() {
    setState(() {
      for (var fish in _fishList) {
        fish.updatePosition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Aquarium'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: 300,
            color: Colors.blue[100],
            child: Stack(
              children: _fishList.map((fish) => fish.buildFish()).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Speed:'),
              Slider(
                value: _fishSpeed,
                min: 1.0,
                max: 10.0,
                onChanged: (value) {
                  setState(() {
                    _fishSpeed = value;
                  });
                },
              ),
              DropdownButton<Color>(
                value: _fishColor,
                items: [
                  DropdownMenuItem(
                    child: Text("Blue"),
                    value: Colors.blue,
                  ),
                  DropdownMenuItem(
                    child: Text("Red"),
                    value: Colors.red,
                  ),
                  DropdownMenuItem(
                    child: Text("Green"),
                    value: Colors.green,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _fishColor = value!;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _addFish,
                child: Text('Add Fish'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _removeFish,
                child: Text('Remove Fish'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/features/Screens/home_sacreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SavePlainScreen extends StatefulWidget {
  const SavePlainScreen({super.key});

  @override
  State<SavePlainScreen> createState() => _SavePlainScreenState();
}

class _SavePlainScreenState extends State<SavePlainScreen> {
  final List<String> files = [];
  final Color orangeColor = const Color(0xFFFF9C00);

  void _addFile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],

      appBar: AppBar(
        backgroundColor: orangeColor,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text(
              "Saved Plains",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Spacer(),
            Text(
              "(${files.length}) Files",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: files.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔸 Placeholder SVG
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/nosaved.svg', // add this in your assets
                      height: 100,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No saved plain !",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Click add button to create new plain",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        files[index],
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        DateTime.now().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addFile,
        backgroundColor: orangeColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;

  CustomStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = ['Items', 'Address', 'Checkout'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isCompleted = stepIndex < currentStep;
          bool isCurrent = stepIndex == currentStep;

          return SizedBox(
            width: 70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor:
                      isCompleted
                          ? Colors.green
                          : isCurrent
                          ? Colors.blue
                          : Colors.grey,
                  child:
                      isCompleted
                          ? Icon(Icons.check, color: Colors.white, size: 18)
                          : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(color: Colors.white),
                          ),
                ),
                SizedBox(height: 6),
                Text(
                  steps[stepIndex],
                  style: GoogleFonts.courierPrime(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return SizedBox(
            width: 40,
            height: 30,
            child: Center(
              child: Container(height: 2, color: Colors.grey, width: 40),
            ),
          );
        }
      }),
    );
  }
}

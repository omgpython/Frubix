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

class VerticalStepper extends StatelessWidget {
  final int currentStep;
  final String orderDate;
  final String deliveryBoyName;
  final String deliveryDate;

  const VerticalStepper({
    super.key,
    required this.currentStep,
    required this.orderDate,
    required this.deliveryBoyName,
    required this.deliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['Order Placed', 'Assigned', 'Delivered'];
    final List<String?> subtitles = [orderDate, deliveryBoyName, deliveryDate];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isCompleted = stepIndex <= currentStep;
          bool isCurrent = stepIndex == currentStep + 1;

          Color circleColor =
              isCompleted
                  ? Colors.green
                  : isCurrent
                  ? Colors.blue
                  : Colors.grey;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step circle
              Column(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: circleColor,
                    child:
                        isCompleted
                            ? Icon(Icons.check, color: Colors.white, size: 18)
                            : Text(
                              '${stepIndex + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                  ),
                  if (stepIndex != titles.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: Colors.grey.shade400,
                      margin: EdgeInsets.only(top: 10),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Title & subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titles[stepIndex],
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        subtitles[stepIndex] ?? '',
                        style: GoogleFonts.courierPrime(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox(height: 12); // Space between steps
        }
      }),
    );
  }
}

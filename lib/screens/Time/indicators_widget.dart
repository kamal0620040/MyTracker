import 'package:flutter/material.dart';
import 'category.dart';

class IndicatorsWidget extends StatelessWidget {
  final Map<String, int> pieSection;

  const IndicatorsWidget(this.pieSection, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Category cat = Category(catId: '5', title: 'title', color: Colors.red);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pieSection.keys
          .toList()
          .map((data) => Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                ),
                child: buildIndicator(
                    color: cat.catidToColor(data),
                    text: cat.catidToTitle(data)),
              ))
          .toList(),
    );
  }

  Widget buildIndicator({
    required Color color,
    required String text,
    double size = 16,
    // Color textColor = const Color(0xff505050)
  }) =>
      Row(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // color: textColor,
            ),
          )
        ],
      );
}

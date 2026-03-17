import 'package:flutter/material.dart';
import 'package:yusr/features/instructions/data/models/instruction_model.dart';

class InstructionsRepository {
  List<InstructionModel> getInstructions() {
    return const [
      InstructionModel(
        title: 'الإفراد',
        subtitle: 'الإحرام بالحج فقط',
        description: 'أن يُحرم بالحج وحده من الميقات، ويقول: لبيك حجًا',
        gradientColors: [Color(0xFFC49A3A), Color(0xFFD4AF37)],
      ),
      InstructionModel(
        title: 'القران',
        subtitle: 'الإحرام بالحج والعمرة معاً',
        description:
            'أن يُحرم بالعمرة والحج معًا من الميقات، ويقول: لبيك عمرة وحجًا',
        gradientColors: [Color(0xFFB8941F), Color(0xFFD4AF37)],
      ),
      InstructionModel(
        title: 'التمتع',
        subtitle: 'العمرة ثم الحج في أشهر الحج',
        description:
            'أن يُحرم بالعمرة في أشهر الحج، ثم يتحلل منها ثم يُحرم بالحج',
        gradientColors: [Color(0xFFD4AF37), Color(0xFFE5C158)],
      ),
    ];
  }
}

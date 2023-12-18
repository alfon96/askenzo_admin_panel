import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/widgets/custom_id_text.dart';
import 'package:flutter/material.dart';
/// The `ExperienceWidget` class is a stateless widget that displays an experience with a custom ID text
/// and an icon.

class ExperienceWidget extends StatelessWidget {
  const ExperienceWidget({super.key, required this.experience});
  final UpdateExperienceModel experience;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 800,
        child: CustomIdText(
          id: '${experience.id}',
          text: experience.title,
          icon: const Icon(Icons.map),
        )
        //const Icon(Icons.beach_access_outlined)

        // child: SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Row(
        //     children: [
        //       Text(
        //         '${experience.id}',
        //         style: const TextStyle(
        //           fontWeight: FontWeight.w800,
        //         ),
        //       ),
        //       const SizedBox(width: 5),
        //       Text(
        //         experience.title,
        //         style: const TextStyle(
        //           color: Colors.black,
        //           fontFamily: ConstantData.fontFamilyBody,
        //         ),
        //       ),
        //       const SizedBox(width: 5),
        //     ],
        //   ),
        // ),
        );
  }
}

import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../styles/spacing_styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key , required, required this.image, required this.title, required this.subtitle, required this.onPressed });
  final String image , title , subtitle; 
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBArHeight * 2,
          child: Column(
            children: [
              Image(
                image: AssetImage(image),
                width: THelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

               SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: onPressed,
                     child: const Text(TTexts.tContinue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

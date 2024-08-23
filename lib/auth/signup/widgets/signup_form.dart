import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../verify_email.dart';
import 'terms_conditions.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(
                  width: TSizes
                      .spaceBtwInputFields), // Adding space between the two fields
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon:
                        Icon(Iconsax.user), // You might want to change the icon
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon:
                  Icon(Iconsax.user_edit), // You might want to change the icon
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon:
                  Icon(Iconsax.direct), // You might want to change the icon
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: TTexts.phoneNo,
              prefixIcon:
                  Icon(Iconsax.call), // You might want to change the icon
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
                labelText: TTexts.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon:
                    Icon(Iconsax.eye_slash) // You might want to change the icon
                ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          const TTermsAndConditionsCheckBox(),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>Get.to(()=>const VerifyEmailScreen()),
              child: const Text(TTexts.createAccount),
            ),
          )
        ],
      ),
    );
  }
}

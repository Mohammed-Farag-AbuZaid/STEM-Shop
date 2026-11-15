import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/data/repositories/authentication_repositrories.dart';
import 'package:stem_shop/features/authentication/controllers/login/loging_controllers.dart';
import 'package:stem_shop/features/authentication/screens/password_configrations/forget_password.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/constants/text_strings.dart';
import 'package:stem_shop/utils/popups/loaders.dart';
import 'package:stem_shop/utils/validators/validation.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBwSections),
        child: Column(
          children: [
            TextFormField(
              controller: controller.email,
              validator: ((value) => TValidator.validateEmail(value)),
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: TSizes.spaceBwInputFields),
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: ((value) =>
                    TValidator.validateEmptyText('Password', value)),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBwInputFields / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: (value) => controller.rememberMe.value =
                            !controller.rememberMe.value,
                      ),
                    ),
                    const Text("Remember me"),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text("Forgot password?"),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordLogin(),
                child: Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBwItems),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _openCreateAccountDialog(context),
                child: const Text("Create a TF account"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateAccountDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final firstNameCtrl = TextEditingController();
    final lastNameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final schoolCtrl = TextEditingController();
    var busy = false;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Create your TF Passport'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: firstNameCtrl,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameCtrl,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) => TValidator.validateEmail(v),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Min 6 characters'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: schoolCtrl,
                    decoration: const InputDecoration(
                      labelText: 'STEM School / School (optional)',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: busy
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setStateDialog(() => busy = true);
                      try {
                        final cred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailCtrl.text.trim(),
                          password: passwordCtrl.text,
                        );
                        final first = firstNameCtrl.text.trim();
                        final last = lastNameCtrl.text.trim();
                        final fullName = '$first $last'.trim();
                        if (cred.user != null) {
                          if (fullName.isNotEmpty) {
                            await cred.user!.updateDisplayName(fullName);
                          }
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(cred.user!.uid)
                              .set({
                            'id': cred.user!.uid,
                            'uid': cred.user!.uid,
                            'firstName': first,
                            'lastName': last,
                            'fullName': fullName,
                            'username': fullName,
                            'email': emailCtrl.text.trim(),
                            'stemSchool': schoolCtrl.text.trim(),
                            'academicLevel': 'STEM',
                            'role': 'student',
                            'registrationDate': FieldValue.serverTimestamp(),
                            'updatedAt': FieldValue.serverTimestamp(),
                          }, SetOptions(merge: true));
                        }
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        AuthenticationRepository.instance.screenRedirect();
                      } on FirebaseAuthException catch (e) {
                        TLoaders.errorSnackBar(
                          title: 'Could not create account',
                          message: e.message ?? e.code,
                        );
                      } catch (e) {
                        TLoaders.errorSnackBar(
                          title: 'Could not create account',
                          message: e.toString(),
                        );
                      } finally {
                        if (ctx.mounted) setStateDialog(() => busy = false);
                      }
                    },
              child: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

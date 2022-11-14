import 'package:ecom_users/auth/auth_service.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:ecom_users/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationPage extends StatefulWidget {
  static const String routeName = '/otp_page';

  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late String phone;
  final textEditingController = TextEditingController();
  bool isFirst = true;
  String inComingOtp = '';
  String vid = '';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      phone = ModalRoute.of(context)!.settings.arguments as String;
      _sendVerificationCode();
      isFirst = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(12),
          shrinkWrap: true,
          children: [
            Text(
              phone,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text(
              'Verify Phone Number',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const Text(
              'An OTP code sent to your mobile number. Enter the OTP code below.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            PinCodeTextField(
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              obscureText: false,
              obscuringCharacter: '*',
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                return null;
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(
                milliseconds: 300,
              ),
              enableActiveFill: true,
              //errorAnimationController: errorController,
              controller: textEditingController,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) {
                inComingOtp = v;
                debugPrint('Completed');
              },
              onChanged: (value) {
                debugPrint(value);
                setState(() {});
              },
              beforeTextPaste: (text) {
                debugPrint('Allowing to paste $text');
                return true;
              },
            ),
            TextButton(
              onPressed: () {
                _verify();
              },
              child: const Text('SEND'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    EasyLoading.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        vid = verificationId;
        showMsg(context, 'Code Sent');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    EasyLoading.dismiss();
  }

  void _verify() {
    EasyLoading.show(status: 'Verifying...');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: vid,
      smsCode: inComingOtp,
    );
    AuthService.currentUser!.linkWithCredential(credential).then((value) async {
      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false)
            .updateUserProfileField(userFieldPhone, phone);
      }
      EasyLoading.dismiss();
      if(mounted)Navigator.pop(context);
    }).catchError((error) {
      EasyLoading.dismiss();
      print(error.toString());
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

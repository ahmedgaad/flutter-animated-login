import 'package:animated_login/animation_enum.dart';
import 'package:animated_login/home.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  bool isLookingRight = false;
  bool isLookingLeft = false;

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    rootBundle.load("assets/animated_login_screen.riv").then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });
    checkPasswordFocusNodeToChangeAnimationState();
  }

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingRight = false;
    isLookingLeft = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint('idle');
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    debugPrint('hands up');
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    debugPrint('hands down');
  }

  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);
    debugPrint('look right');
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(controllerLookLeft);
    debugPrint('look left');
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint('success');
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint('fail');
  }

  void checkPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const Home()));
        });
      } else {
        addFailController();
      }
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = "ahmedgad@gmail.com";
  String testPass = "123456";
  final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Login'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Rive Animation
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtboard!,
                      ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) =>
                          value != testEmail ? "Wrong Email" : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 16 &&
                            !isLookingLeft) {
                          addLookLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 16 &&
                            !isLookingRight) {
                          addLookRightController();
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 29,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (value) =>
                          value != testPass ? "Wrong Password" : null,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password_outlined),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      keyboardType: TextInputType.number,
                      focusNode: passwordFocusNode,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.blue,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                          onPressed: () {
                            passwordFocusNode.unfocus();
                            validateEmailAndPassword();
                          },
                          child: const Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

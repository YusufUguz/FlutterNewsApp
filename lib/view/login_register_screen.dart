import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/constants.dart';
import 'package:news_app/functions/rightToLeft_animation.dart';
import 'package:news_app/services/auth_service.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:news_app/widgets/my_text_form_field.dart';

class LoginRegisterScreen extends StatelessWidget {
  LoginRegisterScreen({super.key});

  final formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailControllerforRegister = TextEditingController();
  final _passwordControllerforRegister = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.appsMainColor,
          centerTitle: true,
          title: const Text(
            'Giriş Yap / Kayıt Ol',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
              indicatorWeight: 5,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Tab(
                  child: Text(
                    'Kayıt Ol',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ]),
        ),
        body: TabBarView(
          children: [
            LoginSection(
                emailController: _emailController,
                passwordController: _passwordController),
            RegisterSection(
                formKey: formKey,
                nameController: _nameController,
                usernameController: _usernameController,
                emailControllerforRegister: _emailControllerforRegister,
                passwordControllerforRegister: _passwordControllerforRegister),
          ],
        ),
      ),
    );
  }
}

class RegisterSection extends StatefulWidget {
  RegisterSection({
    super.key,
    required this.formKey,
    required TextEditingController nameController,
    required TextEditingController usernameController,
    required TextEditingController emailControllerforRegister,
    required TextEditingController passwordControllerforRegister,
  })  : _nameController = nameController,
        _usernameController = usernameController,
        _emailControllerforRegister = emailControllerforRegister,
        _passwordControllerforRegister = passwordControllerforRegister;

  final GlobalKey<FormState> formKey;
  final TextEditingController _nameController;
  final TextEditingController _usernameController;
  final TextEditingController _emailControllerforRegister;
  final TextEditingController _passwordControllerforRegister;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  String? _errorText;

  Future<void> _checkUsernameAvailability(String username) async {
    final usersCollection = widget._firestore.collection('users');
    final querySnapshot =
        await usersCollection.where('username', isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _errorText = 'Bu kullanıcı adı zaten kullanımda.';
      });
    } else {
      setState(() {
        _errorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextFormField(
                    validatorCondition: (value) {
                      const pattern =
                          r'^[A-ZÇĞİÖŞÜ][a-zçğıöşü]+\s[A-ZÇĞİÖŞÜ][a-zçğıöşü]+$';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'Ad ve Soyadınızı Giriniz.';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Ad ve soyadı boşluk bırakarak ve ilk harflerini büyük olarak giriniz.';
                      }
                      return null;
                    },
                    controller: widget._nameController,
                    keyboardType: TextInputType.name,
                    obSecure: false,
                    labelText: 'Ad Soyad',
                    icon: FontAwesomeIcons.user,
                    hintText: 'Adınızı ve Soyadınızı Giriniz..'),
                MyTextFormField(
                  validatorCondition: (value) {
                    _checkUsernameAvailability(widget._usernameController.text);
                    if (value!.isEmpty) {
                      return 'Kullanıcı Adınızı Giriniz.';
                    } else if (_errorText ==
                        'Bu kullanıcı adı zaten kullanımda.') {
                      return 'Bu kullanıcı adı zaten kullanımda.';
                    }
                    return null;
                  },
                  obSecure: false,
                  controller: widget._usernameController,
                  hintText: 'Kullanıcı Adınızı Giriniz..',
                  icon: FontAwesomeIcons.idCard,
                  keyboardType: TextInputType.text,
                  labelText: 'Kullanıcı Adı',
                ),
                MyTextFormField(
                    controller: widget._emailControllerforRegister,
                    validatorCondition: (value) {
                      const pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'E-Posta Giriniz';
                      } else if (!regExp.hasMatch(value)) {
                        return '@ ve .com bulunduran E-Posta Giriniz.';
                      }
                      return null;
                    },
                    obSecure: false,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'E-Posta',
                    icon: FontAwesomeIcons.envelope,
                    hintText: 'E-Posta Adresinizi Giriniz..'),
                MyTextFormField(
                    validatorCondition: (value) {
                      const pattern =
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.])[A-Za-z\d@$!%*?&.]{8,}$';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'Şifrenizi Giriniz.';
                      } else if (!regExp.hasMatch(value)) {
                        return 'Şifreniz en az 1 büyük,1 küçük,1 özel karakter içermeli ve en az 8 haneli olmalıdır.';
                      }
                      return null;
                    },
                    controller: widget._passwordControllerforRegister,
                    keyboardType: TextInputType.text,
                    obSecure: true,
                    labelText: 'Şifre',
                    icon: FontAwesomeIcons.lock,
                    hintText: 'Şifrenizi Giriniz..'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Constants.appsMainColor),
                    onPressed: () async {
                      final isValid = widget.formKey.currentState?.validate();
                      if (isValid!) {
                        widget.formKey.currentState?.save();
                        try {
                          await Auth().signUpWithEmailAndPassword(
                              context: context,
                              name: widget._nameController.text,
                              username: widget._usernameController.text,
                              email: widget._emailControllerforRegister.text,
                              password:
                                  widget._passwordControllerforRegister.text,
                              saved: List.empty());
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text(
                                "Kayıt Başarılı.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: const Text(
                                "Kaydınız başarıyla tamamlandı.Giriş Sayfasına yönlendiriliyorsunuz.",
                                style: TextStyle(
                                    fontFamily: 'Blogger_Sans', fontSize: 18),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) {
                                      return LoginRegisterScreen();
                                    }));
                                  },
                                  child: Container(
                                    color: Constants.appsMainColor,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text(
                                      "Tamam",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(
                                  "Hata!",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  "Bu e-posta adresi zaten kullanılıyor. Lütfen başka bir e-posta adresi seçin.",
                                  style: TextStyle(
                                      fontFamily: 'Blogger_Sans', fontSize: 18),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Constants.appsMainColor,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text(
                                        "Tamam",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            debugPrint(
                                "Firebase Authentication Hatası: ${e.code}");
                          }
                        }
                      }
                      if (isValid == false) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(
                              "Bilgileriniz Yanlış!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              "Bilgileri doğru girdiğinizden emin olunuz.",
                              style: TextStyle(
                                  fontFamily: 'Blogger_Sans', fontSize: 18),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Container(
                                  color: Constants.appsMainColor,
                                  padding: const EdgeInsets.all(14),
                                  child: const Text(
                                    "Tamam",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Kayıt Ol',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Blogger_Sans',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  const LoginSection({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'images/logo2.png',
                  width: 250,
                  height: 200,
                ),
                MyTextFormField(
                    validatorCondition: (value) {
                      const pattern =
                          r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                      final regExp = RegExp(pattern);

                      if (value!.isEmpty) {
                        return 'E-Posta Giriniz';
                      } else if (!regExp.hasMatch(value)) {
                        return '@ ve .com bulunduran E-Posta Giriniz.';
                      }
                      return null;
                    },
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    obSecure: false,
                    labelText: 'E-Posta',
                    icon: FontAwesomeIcons.envelope,
                    hintText: 'E-Posta Adresinizi Giriniz..'),
                MyTextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obSecure: true,
                    labelText: 'Şifre',
                    icon: FontAwesomeIcons.lock,
                    hintText: 'Şifrenizi Giriniz..'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Constants.appsMainColor),
                    onPressed: () {
                      Auth()
                          .signInWithEmailAndPassword(
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text)
                          .catchError((dynamic error) {
                        if (error.code.contains('INVALID_LOGIN_CREDENTIALS')) {
                          errorMessage('Giriş bilgileriniz yanlış.');
                        } else {
                          errorMessage(
                              'Giriş bilgilerinizi girdiğinizden ve doğru olduğundan emin olunuz.');
                        }
                      });
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Blogger_Sans',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            rightToLeftPageAnimation(const MainScreen()));
                      },
                      child: const Text(
                        'Giriş yapmadan devam et',
                        style: TextStyle(
                            fontSize: 20,
                            color: Constants.appsMainColor,
                            decoration: TextDecoration.underline),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void errorMessage(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 14);
}

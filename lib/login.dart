import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool hidePassword = true;

  goCalender(BuildContext context) {
    context.go('/calender');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true, // タイトルを中央揃え
        title: const Text(
          'スマホ版サッカーノート',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30, // フォントサイズを大きく
            fontWeight: FontWeight.bold, // 太字にする
            letterSpacing: 3.0, // 文字間隔を広げる
            fontFamily: 'Roboto',
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.black, Colors.black12],
              ).createShader(bounds);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(color: Colors.white60.withOpacity(0.2)),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 6,
                      left: 12,
                      right: 12,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mail),
                        hintText: 'hogehoge@qmail.com',
                        labelText: 'Email Address',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 6,
                      left: 12,
                      right: 12,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

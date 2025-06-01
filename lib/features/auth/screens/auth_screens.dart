import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/GlobalVariables.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth{
  signin,
  signup,
}

class AuthScreens extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreens({super.key});

  @override
  State<AuthScreens> createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void signUp(){
    authServices.signUpUser(context: context, email: _emailController.text, password: _passwordController.text, name: _nameController.text);
  }
  void signIn(){
    authServices.signInUser(context: context, email: _emailController.text, password: _passwordController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SingleChildScrollView(
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text('Welcome',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,),),
              ListTile(
                tileColor: _auth == Auth.signup ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundCOlor,
                title: const Text("Create Account",style: TextStyle(fontWeight: FontWeight.bold),),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signup, groupValue: _auth, onChanged: (Auth? val){
                  setState(() {
                    _auth= val!;
                  });
                }),
              ),
              if(_auth == Auth.signup)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(controller: _nameController,hintText: "Name",),
                        const SizedBox(height: 10),
                        CustomTextfield(controller: _emailController,hintText: "Email",),
                        const SizedBox(height: 10),
                        CustomTextfield(controller: _passwordController,hintText: "Password",),
                        const SizedBox(height: 10),
                        CustomButton(text: "Sign Up", onTap: (){
                          if(_signUpFormKey.currentState!.validate()){
                            signUp();
                          }
                        })
                      ],
                    ),
                  ),
                ),
              ListTile(
                tileColor: _auth == Auth.signin ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundCOlor,
                title: const Text("Sign In",style: TextStyle(fontWeight: FontWeight.bold),),
                leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signin, groupValue: _auth, onChanged: (Auth? val){
                  setState(() {
                    _auth= val!;
                  });
                }),
              ),
              if(_auth == Auth.signin)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      children: [
                        CustomTextfield(controller: _emailController,hintText: "Email",),
                        const SizedBox(height: 10),
                        CustomTextfield(controller: _passwordController,hintText: "Password",),
                        const SizedBox(height: 10),
                        CustomButton(text: "Sign In", onTap: (){
                          if(_signInFormKey.currentState!.validate()){
                            signIn();
                          }
                        })
                      ],
                    ),
                  ),
                ),
              Text(url)
            ],
          ),
        )),
      ),
    );
  }
}

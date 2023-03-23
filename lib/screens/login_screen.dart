import 'package:flutter/material.dart';
import 'package:productosapp/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});
 
  @override  
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox( height: 250 ),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox( height: 10 ),
                    Text('Login', style: Theme.of(context).textTheme.headline4 ),
                    SizedBox( height: 30 ),
                    
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm()
                    )
                    

                  ],
                )
              ),

              SizedBox( height: 50 ),

              GestureDetector(
                child: Text( 'Olvidaste tu contraseña?',
                style: TextStyle( 
                        fontSize: 18,
                        fontWeight: FontWeight.bold 
                  ),
                ),
                onTap: () {
                  //Navigator.pushReplacementNamed(context, 'restar-password');
                },
              ),

              SizedBox( height: 20 ),

              GestureDetector(
                child: Text( 'Crear una nueva cuenta',
                style: TextStyle( 
                        fontSize: 18,
                        fontWeight: FontWeight.bold 
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'register');
                },
              ),
            ],
          ),
        )
      )
   );
  }
}


class _LoginForm extends StatelessWidget {
  
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);
    final firebaseAuth = Provider.of<FirebaseProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded
              ),
              onChanged: ( value ) => loginForm.email = value,
              validator: ( value ) {
                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = new RegExp(pattern);
                  
                  return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),

            SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => loginForm.password = value,
              validator: ( value ) {
                if(value != null && value.length >= 6){
                    //aqui deberiamos manejar el manejo del estado si hay un error en firebase
                }else{
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
              },
            ),

            SizedBox( height: 30 ),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric( horizontal: 80, vertical: 15),
                child:Text(
                    loginForm.isLoading 
                      ? 'Espere'
                      : 'Ingresar' 
                      ,
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                
                if( !loginForm.isValidForm() ) return;

                firebaseAuth.login(email: loginForm.email, password:loginForm.password);
                
                if(firebaseAuth.isLoginError){
                  print('hubo un error en el login ${firebaseAuth.isLoginError}');
                }else{
                  print('todo esta oc ${firebaseAuth.isLoginError}');
                }
                
                
                // loginForm.isLoading = true;
                //  ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Correo o contraseña incorrectos'),
                //     ),
                //   );
                // loginForm.isLoading = false;
                //Navigator.pushReplacementNamed(context, 'home');
                 
            })
          ],
        ),
      ),
    );
  }
}
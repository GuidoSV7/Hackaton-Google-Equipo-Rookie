import 'package:flutter/material.dart';
import 'package:productosapp/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {

  const RegisterScreen({super.key});
 
  @override  
  Widget build(BuildContext context) {

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox( height: 200 ),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox( height: 10 ),
                    Text('Register', style: Theme.of(context).textTheme.headline4 ),
                    SizedBox( height: 30 ),
                    
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _RegisterForm()
                    )
                  ],
                )
              ),

              SizedBox( height: 50 ),

              GestureDetector(
                child: Text( 'Ya tienes una cuenta?',
                style: TextStyle( 
                        fontSize: 18,
                        fontWeight: FontWeight.bold 
                  ),
                ),
              ),

              SizedBox( height: 20 ),

              GestureDetector(
                child: Text('Inicia Sesion',
                style: TextStyle( 
                        fontSize: 18,
                        fontWeight: FontWeight.bold 
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ],
          ),
        )
      )
   );
  }
}


class _RegisterForm extends StatelessWidget {
  
  const _RegisterForm({super.key});

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
                hintText: 'ejemplo123',
                labelText: 'Nombre de usuario',
                prefixIcon: Icons.perm_identity_rounded
              ),
              onChanged: ( value ) => loginForm.email = value,
              validator: ( value ) {
                  String pattern = r'^[a-zA-Z0-9]+$';
                  RegExp regExp  = new RegExp(pattern);
                  
                  return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El nombre de usuario solo puede contener letras y números';
              },
            ),

            SizedBox( height: 30 ),

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
                  return ((value != null && value.length >= 6) ?  null : 'La contraseña debe tener al menos 6 caracteres');
              },
            ),

            SizedBox( height: 30 ),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Confirmar contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: ( value ) => loginForm.confirmpassword = value,
              validator: ( value ) {
                  return ( (value==loginForm.password)
                    ? null
                    :'Las contraseñas no coinciden'
                  );
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
                      : 'Registrar' 
                      ,
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                
                if( !loginForm.isValidForm() ) return;

                firebaseAuth.register(email: loginForm.email, password:loginForm.password);
                loginForm.isLoading = true;
                firebaseAuth.addUserDatabase(username: loginForm.username, email: loginForm.email, password: loginForm.password, confirmpassword: loginForm.confirmpassword);
                await Future.delayed(Duration(seconds: 2 ));
                Navigator.pushReplacementNamed(context, 'login');
                loginForm.isLoading = false;

            })
          ],
        ),
      ),
    );
  }
}
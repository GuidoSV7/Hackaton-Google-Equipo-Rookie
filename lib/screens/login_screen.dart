import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productosapp/providers/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/auth/FirebaseProvider.dart';

import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});
 
  @override  
  Widget build(BuildContext context) {
    
    final firebaseProvider = Provider.of<FirebaseProvider>(context); 

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
                    Text('Login'/*(!firebaseProvider.isChange)?'Login':'Register'*/, style: Theme.of(context).textTheme.headline4 ),
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
                child: Text( 'Crear una nueva cuenta'/*(!firebaseProvider.isChange)?'Crear una nueva cuenta':'Regresar al login'*/,
                style: TextStyle( 
                        fontSize: 18,
                        fontWeight: FontWeight.bold 
                  ),
                ),
                onTap: () {
                  firebaseProvider.isChange = !firebaseProvider.isChange; 
                  print(firebaseProvider.isChange);
                },
              ),
              SizedBox( height: 50 ),
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
    final firebaseProvider = Provider.of<FirebaseProvider>(context);

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
                 return ((value != null && value.length >= 6) 
                    ? (firebaseProvider.errorPassword != null ? 'Contraseña incorrecta' : null)
                    : 'La contraseña debe tener al menos 6 caracteres');
                /*if(!firebaseProvider.isChange){
                    return ((value != null && value.length >= 6) 
                    ? (firebaseProvider.errorPassword != null ? 'Contraseña incorrecta' : null)
                    : 'La contraseña debe tener al menos 6 caracteres');
                }else{
                   return ((value != null && value.length >= 6) 
                    ?  null
                    : 'La contraseña debe tener al menos 6 caracteres');
                }*/
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
                
                /*Text(
                  (!firebaseProvider.isChange)?
                    loginForm.isLoading 
                      ? 'Espere'
                      : 'Ingresar'
                  :
                   loginForm.isLoading 
                      ? 'Espere'
                      : 'Registrarse'
                  ,*/,
                  style: TextStyle( color: Colors.white ),
                )
              ),
              onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                
                if( !loginForm.isValidForm() ) return;

                  firebaseProvider.login(email: loginForm.email, password:loginForm.password);

                  if( firebaseProvider.user != null ){
                    loginForm.isLoading = true;
                    Navigator.pushReplacementNamed(context, 'home');
                  }else{
                    await Future.delayed(Duration(seconds: 2 ));
                    loginForm.isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo o contraseña incorrectos'),
                      ),
                    );
                  }
                /*if(!firebaseProvider.isChange){
                   firebaseProvider.login(email: loginForm.email, password:loginForm.password);

                  if( firebaseProvider.user != null ){
                    loginForm.isLoading = true;
                    Navigator.pushReplacementNamed(context, 'home');
                  }else{
                    await Future.delayed(Duration(seconds: 2 ));
                    loginForm.isLoading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo o contraseña incorrectos'),
                      ),
                    );
                 }
                }else{
                  firebaseProvider.register(email: loginForm.email, password:loginForm.password);

                  if( firebaseProvider.user != null ){
                    loginForm.isLoading = true;
                    firebaseProvider.isChange = false;
                  }else{
                    await Future.delayed(Duration(seconds: 2 ));
                    loginForm.isLoading = false;
                  }
                }
              }*/
            })
          ],
        ),
      ),
    );
  }
}
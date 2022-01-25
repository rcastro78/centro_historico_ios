//
//  IniciarSesionViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 8/18/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Firebase
import AuthenticationServices



    
       // ASAuthorizationControllerDelegate function for successful authorization

extension IniciarSesionViewController:
ASAuthorizationControllerPresentationContextProviding {

    //For present window
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension IniciarSesionViewController: ASAuthorizationControllerDelegate {
     // ASAuthorizationControllerDelegate function for authorization failed
     
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
}
    


    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
       
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
           print(appleIDCredential)
            let emailValidado = UserDefaults.standard.string(forKey:"emailApple")
            
            if(emailValidado == nil){
                let userId = appleIDCredential.user
                let userFirstName = appleIDCredential.fullName?.givenName
                let userLastName = appleIDCredential.fullName?.familyName
                let userEmail = appleIDCredential.email
                print("User ID: \(userId)")
                print("User First Name: \(userFirstName ?? "")")
                print("User Last Name: \(userLastName ?? "")")
                print("User Email: \(userEmail ?? "")")
                
                
                //Firebase
                
                Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: userEmail)
                    .getDocuments{ (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            let doc = querySnapshot!.count
                            if(doc>0){
                                //Ya existe
                               self.performSegue(withIdentifier:"verificarSegue",sender:self)
                            }else{
                                //self.performSegue(withIdentifier:"registroSegue",sender:self)
                                //Registrar la cuenta
                                //********************
                                
                                var ref : DocumentReference? = nil
                                ref = self.db.collection("usuarios").addDocument(data: [
                                    "nombre": userFirstName!,
                                    "apellido":userLastName!,
                                    "telefono":"",
                                    "appleId": userId,
                                    "picUrl":"",
                                    "plataforma":"iOS",
                                    "email":userEmail,
                                    "fechaRegistro":NSDate().timeIntervalSince1970
                                ]) { err in
                                    if let err = err {
                                        print("Error: \(err)")
                                    } else {
                                        UserDefaults.standard.set(1,forKey: "autenticado")
                                        
                                        if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                                            let alertaAviso = UIAlertController(title: "Centro Histórico", message: "Se ha registrado tu usuario!", preferredStyle: .alert)
                                            alertaAviso.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                                               
                                                self.performSegue(withIdentifier: "verificarSegue", sender: self)
                                                
                                            }))
                                             
                                            let userId = ref?.documentID
                                            UserDefaults.standard.setValue(userId, forKey: "firebaseUserId")
                                            self.present(alertaAviso, animated: true, completion: nil)
                                        }else{
                                            let alertaAviso = UIAlertController(title: "Centro Histórico", message: "User registered successfully!", preferredStyle: .alert)
                                            alertaAviso.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                self.performSegue(withIdentifier: "verificarSegue", sender: self)
                                                
                                                
                                            }))
                                             
                                            let userId = ref?.documentID
                                            UserDefaults.standard.setValue(userId, forKey: "firebaseUserId")
                                            self.present(alertaAviso, animated: true, completion: nil)
                                        }
                                
                                    }
                                //*********************
                                //Fin de registrar cuenta
                              }
                                
                            }
                            
                        }
                        
                    }
                
                //fin Firebase
                
                let appleId = appleIDCredential.user
                let appleUserFirstName = appleIDCredential.fullName?.givenName
                _ = appleIDCredential.fullName?.familyName
                _ = appleIDCredential.email
                
                
                    UserDefaults.standard.set(userFirstName, forKey: "nombre")
                    UserDefaults.standard.set(userLastName, forKey: "apellido")
                    UserDefaults.standard.set(appleId, forKey: "appleId")
                    UserDefaults.standard.set(userEmail, forKey: "emailApple")
                    UserDefaults.standard.set(userEmail, forKey: "email")
                    UserDefaults.standard.set(1,forKey: "autenticado")
                    UserDefaults.standard.set(1,forKey: "cuentaValida")
                    UserDefaults.standard.set(1,forKey: "manzana")
                //imageURL
                UserDefaults.standard.set("",forKey: "imageURL")
                
            
                             
            }
            
            let cuentaValida = UserDefaults.standard.integer(forKey:"cuentaValida")
            if(cuentaValida==1){
                
                print("User ID: \(UserDefaults.standard.string(forKey:"appleId"))")
                print("User First Name: \(UserDefaults.standard.string(forKey:"nombre") ?? "")")
                print("User Last Name: \(UserDefaults.standard.string(forKey:"apellido") ?? "")")
                print("User Email: \(UserDefaults.standard.string(forKey:"email") ?? "")")
                Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: UserDefaults.standard.string(forKey:"email"))
                    .getDocuments{ (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            let doc = querySnapshot!.count
                            if(doc>0){
                                //Ya existe
                               
                                self.performSegue(withIdentifier:"verificarSegue",sender:self)
                            }else{
                                //self.performSegue(withIdentifier:"registroSegue",sender:self)
                            }
                        }
                    }
                
            }
            //}else{
           //     var alert = UIAlertView(title: "Aviso", message: "Debes compartir tu dirección de correo para que podamos validar tu cuenta en nuestro sistema", delegate: nil, cancelButtonTitle: "Aceptar")
            //               alert.show()
                    
            //}
            //Revisar que el correo exista en el server del colegio
           
            
            
            
            
            
            // Write your code here
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            // Write your code here
        }
    }
}





class IniciarSesionViewController: UIViewController,GIDSignInDelegate  {
    
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnNoLogin: UIButton!
    let db = Firestore.firestore()
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("ERROR: \(error.localizedDescription)")
            }
            return
          }
        
        if (error == nil){
            print("El usuario se ha logueado")
            let nombre:String = user.profile.givenName
            let email:String = user.profile.email
            let picUrl = user.profile.imageURL(withDimension: 200)
            
                let pic = "\(user.profile.imageURL(withDimension:200)!)"
                print(pic)
                UserDefaults.standard.set(pic,forKey: "imageURL")
            
            print(nombre)
            print(email)
            //print(picUrl)
            UserDefaults.standard.set(1,forKey: "autenticado")
            
            UserDefaults.standard.set(nombre, forKey: "nombre")
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(0,forKey: "manzana")
            
            
            Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
                .getDocuments{ (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        let doc = querySnapshot!.count
                        if(doc>0){
                            //Ya existe
                           
                            self.performSegue(withIdentifier:"verificarSegue",sender:self)
                        }else{
                            self.performSegue(withIdentifier:"registroSegue",sender:self)
                        }
                    }
                }
        
                    

            
            
            
            //Solo registrar si no existe
            
            
           
        }else{
            print("ERROR: \(error)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        // Do any additional setup after loading the view.
        //comentarlo en pruebas
       // btnDemo.isHidden = true
        
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHeader1.text="Get to know the Historic Center of San Salvador,"
            lblHeader2.text="start new tours."
            btnGoogle.setTitle("Continue with Google", for: .normal)
            btnFB.setTitle("Continue with Facebook", for: .normal)
            btnApple.setTitle("Continue with Apple", for: .normal)
            btnNoLogin.setTitle("Continue without login", for: .normal)
        }
        
        let auth = UserDefaults.standard.integer(forKey: "autenticado")
        if(auth==1){
            let email = UserDefaults.standard.string(forKey: "email")!
            print(email)
            
            let documento = db.collection("usuarios").whereField("email", isEqualTo: email)
            documento.getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.performSegue(withIdentifier: "verificarSegue", sender: self)
                    }
                }
            }
        }
        
        // self.performSegue(withIdentifier: "verificarSegue", sender: self)
        
        
        
        
        
    }
    
    @IBAction func logOut(_ seg:UIStoryboardSegue){
        
    }
    
   
        @IBAction func appleLogin(_ sender: UIButton) {
            actionHandleAppleSignin()
        }
        
    //Acceder a partes de la app que no necesiten autenticación
    //Menú Principal
    //Mapa, puede buscar pero no agregar los lugares
    //Eventos, puede buscar pero no agregar los recorridos
    //Perfil: No acceso a mis recorridos, no acceso a datos personales, cerrar sesión
    @IBAction func LoginNoSesion(_ sender: Any) {
        let firstName  = "Centro"
        let lastName  = "Historico"
    
        let nombre = firstName + " " + lastName
        UserDefaults.standard.set(1,forKey: "autenticado")
        UserDefaults.standard.set(nombre, forKey: "nombre")
        UserDefaults.standard.set("proyectochss@gmail.com", forKey: "email")
        UserDefaults.standard.set(0,forKey: "manzana")
        UserDefaults.standard.set(0,forKey: "autenticado")
        UserDefaults.standard.set("", forKey: "imageURL")
        self.performSegue(withIdentifier:"verificarSegue",sender:self)
    }
   
        @IBAction func facebookLogin(_ sender: UIButton) {
            let loginManager = LoginManager()
            let permission = ["public_profile","email"]
               if let _ = AccessToken.current {
                // Access token available -- user already logged in
                       // Perform log out
               }else{
                loginManager.logIn(permissions: permission, from: self) { [weak self] (result, error) in
     
                    
                    
                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler:
                            { (connection, result, error) -> Void in
                                if (error == nil)
                                {
                                    //everything works print the user data
                                    //                        print(result!)
                                    if let data = result as? NSDictionary
                                    {
                                        
                                  
                                        let firstName  = data.object(forKey: "first_name") as? String
                                        let lastName  = data.object(forKey: "last_name") as? String
                                        
                                        print("FB-DATOS: \(firstName!)")
                                        print("FB-DATOS: \(lastName!)")
                                      
                                        let nombre = firstName! + " " + lastName!
                                        UserDefaults.standard.set(1,forKey: "autenticado")
                                        UserDefaults.standard.set(nombre, forKey: "nombre")
                                        
                                        
                                        
                                        guard let Info = result as? [String: Any] else { return }
                                            if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                               print(imageURL)
                                                UserDefaults.standard.set(imageURL, forKey: "imageURL")
                                            }
                                        
                                        
                                        if let email = data.object(forKey: "email") as? String
                                        {
                                           
                                            UserDefaults.standard.set(email, forKey: "email")
                                            print("FB-DATOS: \(email)")
                                        //Si ya existe en Firebase este email ya no registrarlo, enviarlo directo al menú
                                        
                                            Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
                                                .getDocuments{ (querySnapshot, err) in
                                                    if let err = err {
                                                        print("Error getting documents: \(err)")
                                                    } else {
                                                        
                                                        let doc = querySnapshot!.count
                                                        if(doc>0){
                                                            //Ya existe
                                                            self!.performSegue(withIdentifier:"verificarSegue",sender:self)
                                                        }else{
                                                            self!.performSegue(withIdentifier:"registroSegue",sender:self)
                                                        }
                                                    }
                                                }
                                            
                                            
                                        
                                        }
                                       
                                    }
                                }
                        })
                    
                    
                    
                    
                            guard error == nil else {
                                // Error occurred
                                print(error!.localizedDescription)
                                return
                            }
                            
                         guard let result = result, !result.isCancelled else {
                                print("User cancelled login")
                                return
                            }
                    
                               
                   
                          
                             Profile.loadCurrentProfile { (profile, error) in
                               
                            }
                    
                    
               }
                
           }
        }
        
   
    
        @IBAction func googleSignIn(_ sender: UIButton) {
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }
        
    
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(1,forKey:"cuentaValida")
         
        
    }
    
    
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func actionHandleAppleSignin() {
            if #available(iOS 13.0, *) {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
        }
    
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
           //let sourceViewController = unwindSegue.source
           // Use data from the view controller which initiated the unwind segue
       }
    
    
}
    
    

    
    

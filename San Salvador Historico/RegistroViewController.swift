//
//  RegistroViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 1/25/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import FirebaseFirestore
class RegistroViewController: UIViewController {

    @IBOutlet weak var btnRegistro: UIButton!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var vwEncabezado: UIView!
    @IBOutlet weak var imgPerfil: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFechaNacimiento: UITextField!
    
    @IBOutlet weak var lblNom: UILabel!
    
    @IBOutlet weak var lblRegistro: UILabel!
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblNac: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtNombre.text=UserDefaults.standard.string(forKey: "nombre")
        lblNom.text=UserDefaults.standard.string(forKey: "nombre")
        txtEmail.text=UserDefaults.standard.string(forKey: "email")
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHello.text="HELLO"
            lblRegistro.text="Registration"
            lblNac.text = "Birthdate:"
            lblPhone.text="Phone:"
            lblNombre.text="Name:"
            btnRegistro.setTitle("Sign Up", for: .normal)
            
        }
        let imageURL = UserDefaults.standard.string(forKey: "imageURL")
        print(imageURL!)
        if(imageURL!.count>0){
            let url = URL(string: imageURL!)!
            imgPerfil.cargar(url: url)
            imgPerfil.layer.cornerRadius=imgPerfil.frame.height / 2
        }
      
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarUsuario(_ sender: UIButton) {
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            btnRegistro.setTitle("Signing up...", for: .normal)
        }else{
            btnRegistro.setTitle("Registrando...", for: .normal)
        }
        if(txtNombre.text!.count>0){
        
        //Saber si este correo ya ha sido registrado
            Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: txtEmail.text)
                .getDocuments{ (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        let doc = querySnapshot!.count
                        print("Ya existe: \(doc) registrados")
                        if(doc >= 1){
                          if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                            let alertaAviso = UIAlertController(title: "Centro Histórico", message: "¡Este email ya está registrado!", preferredStyle: .alert)
                            alertaAviso.addAction(UIAlertAction(title: "Iniciar Sesión", style: .default, handler: { action in
                                //self.performSegue(withIdentifier:"backLogin",sender:self)
                            }))
                            self.present(alertaAviso, animated: true, completion: nil)
                           }
                            if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
                              let alertaAviso = UIAlertController(title: "Centro Histórico", message: "This email is already registered!", preferredStyle: .alert)
                              alertaAviso.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                                self.performSegue(withIdentifier:"backLogin",sender:self)
                              }))
                                //self.present(alertaAviso, animated: true, completion: nil)
                             }
                            
                            
                        }else{
                            var ref : DocumentReference? = nil
                            ref = self.db.collection("usuarios").addDocument(data: [
                                "nombre": self.txtNombre.text,
                                "telefono":self.txtTelefono.text,
                                "fechaNacimiento": self.txtFechaNacimiento.text,
                                "picUrl":UserDefaults.standard.string(forKey: "imageURL")!,
                                "plataforma":"iOS",
                                "email":UserDefaults.standard.string(forKey: "email"),
                                "fechaRegistro":NSDate().timeIntervalSince1970
                            ]) { err in
                                if let err = err {
                                    print("Error: \(err)")
                                } else {
                                    
                                    if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                                        let alertaAviso = UIAlertController(title: "Centro Histórico", message: "Se ha registrado tu usuario!", preferredStyle: .alert)
                                        alertaAviso.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                                           
                                            self.performSegue(withIdentifier: "registradoSegue", sender: self)
                                            
                                        }))
                                         
                                        let userId = ref?.documentID
                                        UserDefaults.standard.setValue(userId, forKey: "firebaseUserId")
                                        self.present(alertaAviso, animated: true, completion: nil)
                                    }else{
                                        let alertaAviso = UIAlertController(title: "Centro Histórico", message: "User registered successfully!", preferredStyle: .alert)
                                        alertaAviso.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                            self.performSegue(withIdentifier: "registradoSegue", sender: self)
                                            
                                            
                                        }))
                                         
                                        let userId = ref?.documentID
                                        UserDefaults.standard.setValue(userId, forKey: "firebaseUserId")
                                        self.present(alertaAviso, animated: true, completion: nil)
                                    }
                                    
                                   
                                }
                            }
                                
                            }
                        
                      
                }
            }
            
        
        }else{
            if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
            let alertaAviso = UIAlertController(title: "Centro Histórico", message: "¡No puedes registrarte sin colocar tu nombre!", preferredStyle: .alert)
            alertaAviso.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true)
                
            }))
            }
            
            if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            let alertaAviso = UIAlertController(title: "Centro Histórico", message: "You can't register without a name!", preferredStyle: .alert)
            alertaAviso.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true)
                
            }))
            }
    }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

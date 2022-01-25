//
//  DatosPersonalesViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Firebase
class DatosPersonalesViewController: UIViewController {

    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var lblNombrePerfil: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var lblNombreUsuario: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTelefono: UILabel!
    @IBOutlet weak var lblHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = UserDefaults.standard.string(forKey: "email")
        self.lblEmail.text = email
        
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHeader.text="PERSONAL INFO"
            lblHello.text="HELLO"
            lblName.text="Name:"
            lblTelefono.text="Phone:"
        }
        
        
        
        self.imgFotoPerfil.layer.cornerRadius=32.0
      
        
        Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        self.lblNombreUsuario.text = document.get("nombre")! as! String
                        self.lblNombrePerfil.text = document.get("nombre")! as! String
                        self.lblTelefono.text = document.get("telefono")! as! String
                        self.imgFotoPerfil.layer.cornerRadius=32.0
                        let picUrl = document.get("picUrl")! as! String
                        if(picUrl.count>0){
                        self.imgFotoPerfil.layer.cornerRadius=32.0
                        self.imgFotoPerfil.cargar(url: URL(string:document.get("picUrl")! as! String)!)
                        }
                        
                    }
                }
            }
        // Do any additional setup after loading the view.
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

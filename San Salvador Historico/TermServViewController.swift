//
//  TermServViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Firebase
class TermServViewController: UIViewController {

    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var lblNombrePerfil: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = UserDefaults.standard.string(forKey: "email")
        
       /* self.lblNombrePerfil.text = UserDefaults.standard.string(forKey:"nombre")
        self.imgFotoPerfil.layer.cornerRadius=32.0
        self.imgFotoPerfil.cargar(url: URL(string:UserDefaults.standard.string(forKey: "imageURL")! as! String)!)
      */
        
        
        Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        self.lblNombrePerfil.text = document.get("nombre")! as! String
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

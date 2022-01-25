//
//  MisRecorridosDetalleViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/13/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Firebase
class MisRecorridosDetalleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return misRecorridos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            as! MisRecorridosDetalleTableViewCell
        let r = misRecorridos[indexPath.row]
        cell.lblRecorrido.text = r.post_title
        print("recorridos: \(r.post_title)")
        cell.imgRecorrido.layer.cornerRadius = 32
        let url = URL(string:r.guid)
        if(r.guid.count>5){
            cell.imgRecorrido.cargar(url: url!)
        }else{
            cell.imgRecorrido.image = UIImage(named: "logo_centro_azul")
        }
        
        
        
        return cell
    }
    
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblNombrePerfil: UILabel!
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tableViewRecorridos: UITableView!
    var misRecorridos = [Evento]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRecorridos.delegate=self
        tableViewRecorridos.dataSource=self
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHello.text="HELLO"
        }
        lblHeader.text = UserDefaults.standard.string(forKey: "nombreCat")?.uppercased()
        let email = UserDefaults.standard.string(forKey: "email")
        let cat = Int32(UserDefaults.standard.string(forKey: "idCat")!)!
        print(cat)
        Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                       
                        self.lblNombrePerfil.text = document.get("nombre")! as! String
                        self.imgFotoPerfil.layer.cornerRadius=32.0
                        self.imgFotoPerfil.cargar(url: URL(string:document.get("picUrl")! as! String)!)
                        
                    }
                }
            }
        // Do any additional setup after loading the view.
        
        //Recuperar los recorridos
        
        Firestore.firestore().collection("misRecorridos").whereField("email", isEqualTo: email).whereField("categoria", isEqualTo: cat)
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                       
                        let post_id = document.get("post_id")! as! String
                        let nombre = document.get("nombre")! as! String
                        let guid = document.get("url")! as! String
                        self.misRecorridos.append(Evento(id: "", post_id: post_id, post_name: nombre, post_title: nombre, post_content: "", post_parent: "", guid: guid))
                        print(post_id)
                        
                    }
                    self.tableViewRecorridos.reloadData()
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

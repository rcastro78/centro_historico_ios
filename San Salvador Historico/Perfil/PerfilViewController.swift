//
//  PerfilViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 2/23/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FBSDKLoginKit
import GoogleSignIn
class PerfilViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableViewPerfil: UITableView!
    
    var menu = [MenuPerfil]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            as! PerfilTableViewCell
        let m = menu[indexPath.row]
        cell.lblPerfil.text = m.textoMenu
        cell.imgMenuPerfil.image = m.imgMenu
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var lblNombrePerfil: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let email = UserDefaults.standard.string(forKey: "email")
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHello.text="HELLO"
            lblHeader.text="PROFILE"
        }
        llenarMenu()
        
        
         
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
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = menu[indexPath.row]
        if(m.idMenu==1){
            performSegue(withIdentifier: "infoPersonalSegue", sender: self)
        }
        /*if(m.idMenu==2){
           
        }*/
        if(m.idMenu==2){
            let auth = UserDefaults.standard.integer(forKey: "autenticado")
            if(auth==1){
           performSegue(withIdentifier: "misRecorridosSegue", sender: self)
            }else{
                if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                    let alertaAviso = UIAlertController(title: "Centro Histórico", message: "Debes iniciar sesión para acceder a este recurso", preferredStyle: .alert)
                    alertaAviso.addAction(UIAlertAction(title: "Iniciar Sesión", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "cerrarSesion", sender: self)
                    }))
                    
                    alertaAviso.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    self.present(alertaAviso, animated: true, completion: nil)
                }else{
                    let alertaAviso = UIAlertController(title: "Centro Histórico", message: "You must login in order to access this resource", preferredStyle: .alert)
                    alertaAviso.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                        self.performSegue(withIdentifier: "cerrarSesion", sender: self)
                    }))
                    alertaAviso.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertaAviso, animated: true, completion: nil)
                }
          }
        }
        if(m.idMenu==3){
            if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
                let msg = "Please install app Centro Histórico from Google Play, Huawei Store or AppStore"
                let link = ""
                let urlWhats = "whatsapp://send?text=\(msg+"\n"+link)"

                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                    if let whatsappURL = NSURL(string: urlString) {
                        if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                            UIApplication.shared.openURL(whatsappURL as URL)
                        } else {
                            print("Error")
                        }
                    }
                }
            }else{
                let msg = "Por favor instala la app Centro Histórico desde Google Play, Huawei Store o AppStore"
                let link = ""
                let urlWhats = "whatsapp://send?text=\(msg+"\n"+link)"

                if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                    if let whatsappURL = NSURL(string: urlString) {
                        if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                            UIApplication.shared.openURL(whatsappURL as URL)
                        } else {
                            print("Error")
                        }
                    }
                }
            }
            
            
        }
        
        if(m.idMenu==4){
            guard let numEmergencia = URL(string: "tel://911") else { return }
            UIApplication.shared.open(numEmergencia)
        }
        
        if(m.idMenu==5){
            performSegue(withIdentifier: "termServSegue", sender: self)
        }
        
        if(m.idMenu==6){
            //cerrar sesión en Facebook
            let auth = UserDefaults.standard.integer(forKey: "autenticado")
    
            if(auth==1){
                
            if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
                let refreshAlert = UIAlertController(title: "San Salvador Histórico", message: "Are you sure to close session?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    LoginManager.init().logOut()
                    GIDSignIn.sharedInstance().signOut()
                    UserDefaults.standard.set(0,forKey: "autenticado")
                    //Borrar autenticación
                    self.performSegue(withIdentifier: "cerrarSesion", sender: self)
                }))

                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))

                present(refreshAlert, animated: true, completion: nil)
            }else{
                let refreshAlert = UIAlertController(title: "San Salvador Histórico", message: "¿Estás seguro de cerrar sesión?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Sí", style: .default, handler: { (action: UIAlertAction!) in
                    LoginManager.init().logOut()
                    GIDSignIn.sharedInstance().signOut()
                    UserDefaults.standard.set(0,forKey: "autenticado")
                    //Borrar autenticación
                    self.performSegue(withIdentifier: "cerrarSesion", sender: self)
                }))

                refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))

                present(refreshAlert, animated: true, completion: nil)
                
            }
            
        
           
        }
        }else{
            self.performSegue(withIdentifier: "cerrarSesion", sender: self)
        }
    }
    
    
    
    func llenarMenu(){
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            menu.append(MenuPerfil(idMenu: 1, imgMenu: UIImage(named: "perfil")!, textoMenu: "Personal Date"))
            //menu.append(MenuPerfil(idMenu: 2, imgMenu: UIImage(named: "campana")!, textoMenu: "Notifications"))
            menu.append(MenuPerfil(idMenu: 2, imgMenu: UIImage(named: "marker")!, textoMenu: "My Trips"))
            menu.append(MenuPerfil(idMenu: 3, imgMenu: UIImage(named: "amigos")!, textoMenu: "Invite your friends"))
            menu.append(MenuPerfil(idMenu: 4, imgMenu: UIImage(named: "menu_world")!, textoMenu: "Contact assistance service"))
            menu.append(MenuPerfil(idMenu: 5, imgMenu: UIImage(named: "terminos")!, textoMenu: "Terms of Service"))
            menu.append(MenuPerfil(idMenu: 6, imgMenu: UIImage(named: "perfil")!, textoMenu: "Close Session"))
        }else{
            menu.append(MenuPerfil(idMenu: 1, imgMenu: UIImage(named: "perfil")!, textoMenu: "Datos Personales"))
            //menu.append(MenuPerfil(idMenu: 2, imgMenu: UIImage(named: "campana")!, textoMenu: "Notificaciones"))
            menu.append(MenuPerfil(idMenu: 2, imgMenu: UIImage(named: "marker")!, textoMenu: "Mis Recorridos"))
            menu.append(MenuPerfil(idMenu: 3, imgMenu: UIImage(named: "amigos")!, textoMenu: "Invita a tus amigos"))
            menu.append(MenuPerfil(idMenu: 4, imgMenu: UIImage(named: "menu_world")!, textoMenu: "Contacta al servicio de asistencia"))
            menu.append(MenuPerfil(idMenu: 5, imgMenu: UIImage(named: "terminos")!, textoMenu: "Términos de Servicio"))
            menu.append(MenuPerfil(idMenu: 6, imgMenu: UIImage(named: "perfil")!, textoMenu: "Cerrar Sesión"))
        }
        
        tableViewPerfil.reloadData()
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

//
//  DetalleLugarViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/8/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import WebKit


class DetalleLugarViewController: UIViewController {
    @IBOutlet weak var imgFotoLugar: UIImageView!
    //@IBOutlet weak var webContent: UITextView!
    @IBOutlet weak var webContent: WKWebView!
    
    
    var lugares = [Lugar]()
    var pid:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.title = UserDefaults.standard.string(forKey: "titulo")
        let latitud = UserDefaults.standard.string(forKey: "latLugar")
        let longitud = UserDefaults.standard.string(forKey: "lngLugar")
        let post_id = UserDefaults.standard.string(forKey: "post_id")
        let lang = LocalizationSystem.sharedInstance.getLanguage()
        let direccion = APPURL.URL_PRINCIPAL+RutasGET.LUGARES_COORDENADAS+"?lat=\(latitud!)&lng=\(longitud!)&lang=\(lang)"
        
       
        getLugarCoordenadas(direccion: direccion)
        
        
        
        
        
       
    }
    
    @IBAction func agregarLugar(_ sender: UIBarButtonItem) {
        //Obtener los detalles del lugar para agregarlo
        let autenticado = UserDefaults.standard.integer(forKey:"autenticado")
        
        
        if(autenticado==1){
            let fid = UserDefaults.standard.string(forKey:"firebaseUserId")
            let fecha = Int64(NSDate().timeIntervalSince1970*1000)
            let db = Firestore.firestore()
            let dict = ["email": UserDefaults.standard.string(forKey: "email")!,
                "nombre": UserDefaults.standard.string(forKey: "titulo")!,
                               "post_id": pid,
                               "categoria":  Int32(UserDefaults.standard.string(forKey: "idCat")!),
                               "userFirebaseID":fid,
                               "fechaRegistro":"\(fecha)",
                               "plataforma":"iOS",
                               "url":self.lugares[0].url] as [String : Any]
            
            
            
            //Verificar que este correo no tenga agregado este lugar
            Firestore.firestore().collection("misRecorridos").whereField("post_id", isEqualTo: pid).whereField("email", isEqualTo: UserDefaults.standard.string(forKey:"email"))
                .getDocuments{ (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        if(!querySnapshot!.isEmpty){
                            
                            let doc  = querySnapshot?.documents[0]
                            
                           
                                if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                                    
                                    let alerta = UIAlertController(title: "Centro Histórico", message: "Ya agregaste este lugar", preferredStyle: .alert)
                                    alerta.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: { action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(alerta, animated: true, completion: nil)
                                }else{
                                    let alerta = UIAlertController(title: "Centro Histórico", message: "You already added this place", preferredStyle: .alert)
                                    alerta.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                                        self.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(alerta, animated: true, completion: nil)
                                }
                            
                           
                        }else{
                            if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                                let alertaAviso = UIAlertController(title: "Centro Histórico", message: "¿Deseas registrar este lugar en tus recorridos?", preferredStyle: .alert)
                                alertaAviso.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                                    db.collection("misRecorridos").addDocument(data: dict)
                                    
                                }))
                                
                                alertaAviso.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { action in
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                self.present(alertaAviso, animated: true, completion: nil)
                            }else{
                                let alertaAviso = UIAlertController(title: "Centro Histórico", message: "Would you like to register this place in your trips?", preferredStyle: .alert)
                                alertaAviso.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                    db.collection("misRecorridos").addDocument(data: dict)
                                }))
                                alertaAviso.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alertaAviso, animated: true, completion: nil)
                            }
                        }
                        
                    }
                    
                }
        }else{
            //Mensaje que no se logueó
            if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                let alertaAviso = UIAlertController(title: "Centro Histórico", message: "Debes iniciar sesión para agregar este lugar", preferredStyle: .alert)
                alertaAviso.addAction(UIAlertAction(title: "Iniciar Sesión", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "exitLoginSegue", sender: self)
                }))
                
                alertaAviso.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alertaAviso, animated: true, completion: nil)
            }else{
                let alertaAviso = UIAlertController(title: "Centro Histórico", message: "You must login to add this place", preferredStyle: .alert)
                alertaAviso.addAction(UIAlertAction(title: "Login", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "exitLoginSegue", sender: self)
                }))
                alertaAviso.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertaAviso, animated: true, completion: nil)
            }
        }
        
    
              
        
       
    }
    
    
    /*func getPostContent(direccion:String){
        AF.request(direccion,method: .get)
            .responseString{
                response in
                if response.data != nil{
                    let json = try? JSON(data: response.data!)
                    self.webContent.text = json![0]["content"].stringValue
                    
                    
                }else{
                    print("error del content")
                }
            }
    }*/
    
    //Con las coordenadas obtener los detalles del lugar
    func getLugarCoordenadas(direccion:String){
        lugares.removeAll()
        //private String id,post_title,url,post_type,thumbnail,longitud,latitud,tipo;
        AF.request(direccion, method: .get)
          .responseJSON { response in
              if response.data != nil {
                let json = try? JSON(data: response.data!)
               //
                for i in 0 ... json!.count-1 {
                    let id = json![i]["ID"].stringValue
                    let post_title = json![i]["post_title"].stringValue
                    let url = json![i]["url"].stringValue
                    let post_type = json![i]["post_type"].stringValue
                    let thumbnail = json![i]["thumbnail"].stringValue
                    let longitud = json![i]["longitud"].stringValue
                    let latitud = json![i]["latitud"].stringValue
                    let tipo = ""
                    let language_code = json![i]["language_code"].stringValue
                    self.pid = id
                    if(language_code == LocalizationSystem.sharedInstance.getLanguage()){
                    self.lugares.append(Lugar(id: id, post_title: post_title, url: url, post_type: post_type, thumbnail: thumbnail, longitud: longitud, latitud: latitud, tipo: tipo,language_code: language_code))
                    }
                }
              }
            
            
            if(self.lugares[0].url != ""){
                let dir2 = "https://www.sansalvadorhistorico.com/app/getPostContentTempB.php?pid=\(self.lugares[0].id)"
                print(dir2)
                let link = URL(string:dir2)!
                      let request = URLRequest(url: link)
                self.webContent.contentMode = .scaleAspectFit
                self.webContent.load(request)
                self.webContent.scrollView.isScrollEnabled = true
                self.webContent.scrollView.bounces = false
                self.webContent.allowsBackForwardNavigationGestures = false
                
                
                
                
                
                //self.getPostContent(direccion: dir2)
                self.imgFotoLugar.cargar(url: URL(string: self.lugares[0].url)!)
            }
            //self.txtDescripcion.text = self.lugares[0].post_title
          }
        
        
        
        /*let req = AF.request(direccion)
        req.responseJSON { (data) in
            var json = JSON(data)
            print(json["term_id"])
          }*/
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

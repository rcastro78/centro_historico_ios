//
//  EventoViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/6/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
class EventoViewController: UIViewController {

    @IBOutlet weak var imgEvento: UIImageView!
    @IBOutlet weak var txtPostContent: UITextView!
    var postContent:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        let guid = UserDefaults.standard.string(forKey: "guid")
        let post_id = UserDefaults.standard.string(forKey: "post_id")
        self.navigationItem.title = UserDefaults.standard.string(forKey: "post_title")
        //self.txtPostContent.text = post_content
        self.imgEvento.cargar(url: URL(string: guid!)!)
        getContenidoPost(direccion: APPURL.URL_PRINCIPAL+RutasGET.POST_CONTENT+"?pid=\(post_id)")
    }
    
    @IBAction func agregarEvento(_ sender: Any) {
        //Guardar evento en firebase
        let autenticado = UserDefaults.standard.integer(forKey: "autenticado")
        
        if(autenticado==1){
            let fid = UserDefaults.standard.string(forKey:"firebaseUserId")
        
        let db = Firestore.firestore()
        let dict = ["guid": UserDefaults.standard.string(forKey: "guid")!,
                           "post_id": UserDefaults.standard.string(forKey: "post_id")!,
                           "post_title": UserDefaults.standard.string(forKey: "post_title")!,
                           "post_content": postContent,
                           "email":UserDefaults.standard.string(forKey: "email")!,
                           "userFirebaseID":fid]
               db.collection("eventos").addDocument(data: dict)
        
        
        /*
         pf6QnbwwlOyKPfg50usB
         
         */
        }else{
            if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                let alertaAviso = UIAlertController(title: "Centro Histórico", message: "Debes iniciar sesión para agregar este evento", preferredStyle: .alert)
                alertaAviso.addAction(UIAlertAction(title: "Iniciar Sesión", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "exitLoginSegue", sender: self)
                }))
                
                alertaAviso.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                self.present(alertaAviso, animated: true, completion: nil)
            }else{
                let alertaAviso = UIAlertController(title: "Centro Histórico", message: "You must login to add this event", preferredStyle: .alert)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getContenidoPost(direccion:String){
    
        AF.request(direccion, method: .get)
          .responseString { response in
              if response.data != nil {
                print(response.data)
                self.txtPostContent.text=response.data as? String
                self.postContent = (response.data as? String)!
              }
          }
        
    }
    
    

}

//
//  NotificacionesViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/11/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Firebase
import SQLite3
class NotificacionesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var lblNombrePerfil: UILabel!
    var db: OpaquePointer?
    @IBOutlet weak var tableViewNotificaciones: UITableView!
    var notificaciones = [Notificacion]()
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificaciones.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            as! NotificacionTableViewCell
        let n = notificaciones[indexPath.row]

        cell.lblTitulo.text = n.titulo
        cell.lblDescrip.text = n.texto
        cell.lblFecha.text = n.fecha
        let fotoUrl = n.foto
        cell.imgFoto.cargar(url: URL(string:fotoUrl)!)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let email = UserDefaults.standard.string(forKey: "email")
        
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHeader.text="NOTIFICATIONS"
            lblHello.text="HELLO"
        }
        
        
        Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        self.lblNombrePerfil.text = document.get("nombre")! as! String
                        self.imgFotoPerfil.layer.cornerRadius=32.0
                        self.imgFotoPerfil.cargar(url: URL(string:document.get("picUrl")! as! String)!)
                        
                    }
                }
            }
        
        
        
       
        // Do any additional setup after loading the view.
    }
    
    
    //Método para cargar las notificaciones
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getNotificaciones(){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(_APP.DB_NAME)
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        let consulta = "SELECT * from tbl_notificaciones order by post_id"
     var queryStatement: OpaquePointer? = nil
     
     if sqlite3_prepare_v2(db, consulta, -1, &queryStatement, nil) == SQLITE_OK {
    
          while(sqlite3_step(queryStatement) == SQLITE_ROW) {
            let post_id = sqlite3_column_text(queryStatement, 0)
            let post_title = sqlite3_column_text(queryStatement, 1)
            let content = sqlite3_column_text(queryStatement, 2)
            let guid = sqlite3_column_text(queryStatement, 3)
            let date_published = sqlite3_column_text(queryStatement, 4)
            //id:String,titulo:String,texto:String,fecha:String,foto:String
            let mili = Int64(String(cString: date_published!))
            let d = NSDate(timeIntervalSince1970: TimeInterval(mili! / 1000))
            let f = DateFormatter()
            f.dateFormat = "dd/MM/yyyy"
            f.locale = NSLocale(localeIdentifier: "es_ES") as Locale?
            let fecha:String = f.string(from: d as Date)
            self.notificaciones.append(Notificacion(id: String(cString: post_id!), titulo: String(cString: post_title!), texto: String(cString: content!), fecha: fecha, foto: String(cString: guid!)))
            
          }
        
        self.tableViewNotificaciones.reloadData()
        
    }
    }

}

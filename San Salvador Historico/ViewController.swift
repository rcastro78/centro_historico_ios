//
//  ViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 12/9/20.
//  Copyright © 2020 The Kitchen DS. All rights reserved.
//

import UIKit
import SQLite3



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}


extension UIImageView {
    func cargar(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


class ViewController: UIViewController {
    var db: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(1, forKey: "filtrado")
        //Crear tabla de notificaciones
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(_APP.DB_NAME)
        
        if(sqlite3_open(fileUrl.path, &db) != SQLITE_OK){
            print("Error en la base de datos")
        }
        
        /*
         idCircular,idUsuario,nombre,textoCircular,no_leida,leida,favorita,compartida,eliminada,created_at,fechaIcs,horaInicioIcs,horaFinIcs,nivel
         */
        
        let crearTablaNotificaciones = "CREATE TABLE IF NOT EXISTS tbl_notificaciones(post_id TEXT UNIQUE, post_title TEXT, content TEXT, guid TEXT, date_published TEXT)"
        if sqlite3_exec(db, crearTablaNotificaciones, nil, nil, nil) != SQLITE_OK {
            print("Error creando la tabla")
        }else{
           print("creada la tabla")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 4.0, execute: {
           self.performSegue(withIdentifier:"inicioSegue",sender: self)
        })
        
        
        
    }

   //202097195211-43rt0kfq8sqr6vbac7mc90gh7i7dspv6.apps.googleusercontent.com
   //com.googleusercontent.apps.202097195211-43rt0kfq8sqr6vbac7mc90gh7i7dspv6

}


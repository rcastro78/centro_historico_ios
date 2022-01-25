//
//  MenuPrincipalViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 1/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Foundation
import FirebaseMessaging

class MenuPrincipalViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITabBarControllerDelegate {
    
    var menuItems = [MenuPrincipal]()
    @IBOutlet weak var collectionViewMenu: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        llenarMenu()
        // Do any additional setup after loading the view.
        Messaging.messaging().subscribe(toTopic: "centro_historico") { error in
            if(error != nil){
                print("Suscrito al topico centro historico")
            }else{
                print("Suscrito al topico: \(error)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
   
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let m = menuItems[indexPath.row]
        UserDefaults.standard.set(m.texto, forKey: "catName")
        UserDefaults.standard.setValue(0, forKey: "filtrado")
        UserDefaults.standard.synchronize()
        print(m.texto)
        self.tabBarController?.selectedIndex = 1
       
        return true
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath)
                              as! MenuCollectionViewCell
             
        //cell.view.layer.shadowOpacity = 1
        cell.view.layer.shadowRadius = 0
        cell.view.layer.masksToBounds = false
        cell.view.layer.cornerRadius = 6.0
        cell.layer.borderColor = UIColor.clear.cgColor
                let m = menuItems[indexPath.row]
                // cell.imgPromocion.layer.cornerRadius = 6.0
                //cell.lblItem.text = m.texto
                cell.imgItem.image = m.imagen
                return cell
    }

    
    func llenarMenu(){
        //if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
        menuItems.append(MenuPrincipal(id: 197, imagen: UIImage(named: "principal1")!, texto: "Bares y Cafés", color: .blue))
        menuItems.append(MenuPrincipal(id: 35, imagen: UIImage(named: "principal2")!, texto: "Entretenimiento", color: .blue))
        menuItems.append(MenuPrincipal(id: 183, imagen: UIImage(named: "principal3")!, texto: "Cultura", color: .blue))
        menuItems.append(MenuPrincipal(id: 464, imagen: UIImage(named: "principal4")!, texto: "Restaurantes", color: .blue))
        menuItems.append(MenuPrincipal(id: 157, imagen: UIImage(named: "principal5")!, texto: "Religión", color: .blue))
        menuItems.append(MenuPrincipal(id: 302, imagen: UIImage(named: "principal6")!, texto: "Plazas y Parques", color: .blue))
        //}else{
          
        //}
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

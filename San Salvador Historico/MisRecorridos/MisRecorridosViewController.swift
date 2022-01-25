//
//  MisRecorridosViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Firebase
class MisRecorridosViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    let Alojamiento=157
    let Accommodation=535
    var alojamiento:Int=0
        let Bancos=69;
    let Banks=532
    var bancos:Int=0
        let Bares=197;
    let Bars=537
    var bares:Int=0
        let Bibliotecas=468;
    let Libraries=547
    var biblio:Int=0
        let Comida=469;
    let Food=548
    var comida:Int=0
        let Compras=470;
    let Shopping = 549
    var compras:Int=0
        let Instituciones=478;
    let Institutions=552;
    var instituc:Int=0
        let Mercados=71;
    let Markets=533;
    var mercados:Int=0
        let Museos=290;
    let Museums=539;
    var museos:Int=0
        let Otros=474;
    let Others=551
    var otros:Int=0
    let Parada=223;
    let BusStations=538
    var paradas:Int=0
    let Parqueo=442
    let Parking=541
    var parqueos:Int=0
    let Religion=464;
    let ReligionEn=545
    var religion:Int=0
    let Restaurantes=35
    let Restaurants=531
    var restaurantes:Int=0
    let Parques=302
    let Parks=540
    var parques:Int=0
    let Salud=445;
    let Health=542
    var salud:Int=0
    let  Educativos=472
    let  Education=550
    var educativos:Int=0
    let Municipales=452
    let  Municipal=544
    var municipales:Int=0
    let Interes=465
    let Interest=546
    var interes:Int=0
    let Emblematicos=183
    let Emblematics=536
    var emblematicos:Int=0
    let Supermercados=145
    let Supermarkets=534
    var supermercados:Int=0
    let Tour=451
    
    var tour:Int=0
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return misRecorridos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let m = misRecorridos[indexPath.row]
        //UserDefaults.standard.set(m.id, forKey: "menuId")
        UserDefaults.standard.set(m.nombre, forKey: "nombreCat")
        UserDefaults.standard.set(m.idMenu, forKey: "idCat")
        
        performSegue(withIdentifier: "misRecorridosDetaSegue", sender: self)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath)
                              as! MisRecorridosCollectionViewCell
             
        //cell.view.layer.shadowOpacity = 1
        
       
        
        cell.layer.shadowRadius = 0
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 6.0
        cell.layer.borderColor = UIColor.clear.cgColor
        let m = misRecorridos[indexPath.row]
        cell.lblNombreCategoria.text = m.nombre
        var part:String=""
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
           
            if(m.cantidad == "1"){
                part=" place"
            }else{
                part=" places"
            }
            cell.lblCantidad.text = m.cantidad + part
        }else{
            if(m.cantidad == "1"){
                part=" lugar"
            }else{
                part=" lugares"
            }
            cell.lblCantidad.text = m.cantidad + part
        }
        
        cell.imgPrincipal.image = m.imagenPrincipal
        cell.icono.image = m.icono
        cell.icono.layer.cornerRadius=18.0
        return cell
    }
    

    @IBOutlet weak var collectionViewRecorridos: UICollectionView!
    var misRecorridos = [MiRecorrido]()
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let email = UserDefaults.standard.string(forKey: "email")
        
        if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
            lblHello.text="HELLO"
            lblHeader.text="MY TRIPS"
        }
        
        
        Firestore.firestore().collection("usuarios").whereField("email", isEqualTo: email)
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        self.lblNombre.text = document.get("nombre")! as! String
                        self.imgFotoPerfil.layer.cornerRadius=32.0
                        let picUrl = document.get("picUrl")! as! String
                        if(picUrl.count>0){
                        self.imgFotoPerfil.layer.cornerRadius=32.0
                        self.imgFotoPerfil.cargar(url: URL(string:document.get("picUrl")! as! String)!)
                        }
                        
                    }
                }
            }
        llenarMenu()
    }
    
    
    func llenarMenu(){
        let db = Firestore.firestore()
        let email = UserDefaults.standard.string(forKey: "email")
        let recorridos = db.collection("misRecorridos").whereField("email", isEqualTo: email).getDocuments{ [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let idCat = document.get("categoria") as! Int32
                    
                    
                    if(idCat==self.Bares || idCat==self.Bars){
                        self.bares+=1
                     }
                    if(idCat==self.Alojamiento || idCat==self.Accommodation){
                        self.alojamiento+=1
                     }
                    if(idCat==self.Bancos || idCat==self.Banks){
                        self.bancos+=1
                    }
                    if(idCat==self.Bibliotecas || idCat==self.Libraries){
                        self.biblio+=1
                    }
                    if(idCat==self.Comida || idCat==self.Food){
                        self.comida+=1
                    }
                    if(idCat==self.Compras || idCat==self.Shopping){
                        self.compras+=1
                    }
                    if(idCat==self.Instituciones || idCat==self.Institutions){
                        self.instituc+=1
                     }
                    if(idCat==self.Mercados || idCat==self.Markets){
                        self.mercados+=1
                     }
                    if(idCat==self.Museos || idCat==self.Museums){
                        self.museos+=1
                    }
                    if(idCat==self.Otros || idCat==self.Others){
                        self.otros+=1
                     }
                    if(idCat==self.Parada || idCat==self.BusStations){
                        self.paradas+=1
                    }
                    if(idCat==self.Parqueo || idCat==self.Parks){
                        self.parqueos+=1
                     }
                    if(idCat==self.Religion || idCat==self.ReligionEn){
                        self.religion+=1
                     }
                    if(idCat==self.Restaurantes || idCat==self.Restaurants){
                        self.restaurantes+=1
                     }
                    if(idCat==self.Parques || idCat==self.Parks){
                        self.parques+=1
                     }
                    if(idCat==self.Salud || idCat==self.Health){
                        self.salud+=1
                     }
                    if(idCat==self.Educativos || idCat==self.Education){
                        self.educativos+=1
                    }
                    if(idCat==self.Municipales || idCat==self.Municipal){
                        self.municipales+=1
                     }
                    if(idCat==self.Interes || idCat==self.Interest){
                        self.interes+=1
                    }
                    if(idCat==self.Emblematicos || idCat==self.Emblematics){
                        self.emblematicos+=1
                    }
                    if(idCat==self.Supermercados || idCat==self.Supermarkets){
                        self.supermercados+=1
                    }
                    if(idCat==self.Tour){
                        self.tour+=1
                    }
                    
                }
                if (LocalizationSystem.sharedInstance.getLanguage() == "en") {
                    
                    if(self.alojamiento>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Accommodation, imagenPrincipal: UIImage(named: "alojamiento_item")!, icono: UIImage(named: "alojamiento_red")!, nombre: "Accommodation", cantidad: "\(self.alojamiento)"))
                    }
                    if(self.bares>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Bars, imagenPrincipal: UIImage(named: "bares_item")!, icono: UIImage(named: "bares_red")!, nombre: "Bars and Cafes", cantidad: "\(self.bares)"))
                    }
                    if(self.bancos>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Banks, imagenPrincipal: UIImage(named: "bares_item")!, icono: UIImage(named: "bares_red")!, nombre: "Banks", cantidad: "\(self.bancos)"))
                    }
                    if(self.biblio>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Libraries, imagenPrincipal: UIImage(named: "biblioteca_item")!, icono: UIImage(named: "templos_2_red")!, nombre: "Libraries", cantidad: "\(self.biblio)"))
                    }
                    
                    if(self.comida>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Food, imagenPrincipal: UIImage(named: "subway")!, icono: UIImage(named: "templos_2_red")!, nombre: "Fast Food", cantidad: "\(self.comida)"))
                    }
                    
                    if(self.compras>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Shopping, imagenPrincipal: UIImage(named: "compras_item")!, icono: UIImage(named: "centros_com")!, nombre: "Shopping", cantidad: "\(self.compras)"))
                    }
                    
                    if(self.instituc>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Institutions, imagenPrincipal: UIImage(named: "instituciones_item")!, icono: UIImage(named: "monumentos_red")!, nombre: "Institutions", cantidad: "\(self.instituc)"))
                    }
                    if(self.mercados>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Markets, imagenPrincipal: UIImage(named: "mercado_item")!, icono: UIImage(named: "tiendas_red")!, nombre: "Markets", cantidad: "\(self.mercados)"))
                    }
                    
                    if(self.museos>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Museums, imagenPrincipal: UIImage(named: "museos_item")!, icono: UIImage(named: "sitios_red")!, nombre: "Museums", cantidad: "\(self.museos)"))
                    }
                    
                    if(self.otros>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Others, imagenPrincipal: UIImage(named: "otros_item")!, icono: UIImage(named: "buscar_red")!, nombre: "Others", cantidad: "\(self.otros)"))
                    }
                    
                    if(self.paradas>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.BusStations, imagenPrincipal: UIImage(named: "otros_item")!, icono: UIImage(named: "parada_red")!, nombre: "Bus Stations", cantidad: "\(self.paradas)"))
                    }
                    if(self.parques>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Parks, imagenPrincipal: UIImage(named: "parques_item")!, icono: UIImage(named: "parques_red")!, nombre: "Squares y Parks", cantidad: "\(self.parques)"))
                    }
                    
                    if(self.religion>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.ReligionEn, imagenPrincipal: UIImage(named: "iglesia_item")!, icono: UIImage(named: "religion_red")!, nombre: "Churches", cantidad: "\(self.religion)"))
                    }
                    
                    if(self.salud>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Health, imagenPrincipal: UIImage(named: "salud")!, icono: UIImage(named: "templos_red")!, nombre: "Health", cantidad: "\(self.salud)"))
                    }
                    
                    if(self.educativos>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Education, imagenPrincipal: UIImage(named: "educativos_item")!, icono: UIImage(named: "academico_red")!, nombre: "Educational Serv. ", cantidad: "\(self.educativos)"))
                    }
                    
                    if(self.municipales>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Municipal, imagenPrincipal: UIImage(named: "municipales_item")!, icono: UIImage(named: "templos_red")!, nombre: "Municipal Serv.", cantidad: "\(self.municipales)"))
                    }
                    if(self.interes>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Interest, imagenPrincipal: UIImage(named: "entretenimiento_item")!, icono: UIImage(named: "cines_red")!, nombre: "Places of interest", cantidad: "\(self.interes)"))
                    }
                    if(self.supermercados>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Supermarkets, imagenPrincipal: UIImage(named: "selectos")!, icono: UIImage(named: "super_red")!, nombre: "Supermarkets", cantidad: "\(self.supermercados)"))
                    }
                    if(self.tour>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Tour, imagenPrincipal: UIImage(named: "entretenimiento_item")!, icono: UIImage(named: "icono_360_red")!, nombre: "Tour", cantidad: "\(self.tour)"))
                    }
                    
                    
                    if(self.restaurantes>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Restaurantes, imagenPrincipal: UIImage(named: "restaurantes_item")!, icono: UIImage(named: "restaurantes_red")!, nombre: "Restaurants", cantidad: "\(self.restaurantes)"))
                    }
                    
                }else{
                    if(self.alojamiento>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Alojamiento, imagenPrincipal: UIImage(named: "alojamiento_item")!, icono: UIImage(named: "alojamiento_red")!, nombre: "Alojamiento", cantidad: "\(self.alojamiento)"))
                    }
                    if(self.bares>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Bares, imagenPrincipal: UIImage(named: "bares_item")!, icono: UIImage(named: "bares_red")!, nombre: "Bares y Cafés", cantidad: "\(self.bares)"))
                    }
                    if(self.bancos>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Bancos, imagenPrincipal: UIImage(named: "bares_item")!, icono: UIImage(named: "bares_red")!, nombre: "Bancos", cantidad: "\(self.bancos)"))
                    }
                    if(self.biblio>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Bibliotecas, imagenPrincipal: UIImage(named: "biblioteca_item")!, icono: UIImage(named: "templos_2_red")!, nombre: "Bibliotecas", cantidad: "\(self.biblio)"))
                    }
                    
                    if(self.comida>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Comida, imagenPrincipal: UIImage(named: "subway")!, icono: UIImage(named: "templos_2_red")!, nombre: "Comida", cantidad: "\(self.comida)"))
                    }
                    
                    if(self.compras>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Compras, imagenPrincipal: UIImage(named: "compras_item")!, icono: UIImage(named: "centros_com")!, nombre: "Compras", cantidad: "\(self.compras)"))
                    }
                    
                    if(self.instituc>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Instituciones, imagenPrincipal: UIImage(named: "instituciones_item")!, icono: UIImage(named: "monumentos_red")!, nombre: "Instituciones", cantidad: "\(self.instituc)"))
                    }
                    if(self.mercados>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Mercados, imagenPrincipal: UIImage(named: "mercado_item")!, icono: UIImage(named: "tiendas_red")!, nombre: "Mercados", cantidad: "\(self.mercados)"))
                    }
                    
                    if(self.museos>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Museos, imagenPrincipal: UIImage(named: "museos_item")!, icono: UIImage(named: "sitios_red")!, nombre: "Museos", cantidad: "\(self.museos)"))
                    }
                    
                    if(self.otros>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Otros, imagenPrincipal: UIImage(named: "otros_item")!, icono: UIImage(named: "buscar_red")!, nombre: "Otros", cantidad: "\(self.otros)"))
                    }
                    
                    if(self.paradas>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Parada, imagenPrincipal: UIImage(named: "otros_item")!, icono: UIImage(named: "parada_red")!, nombre: "Paradas", cantidad: "\(self.paradas)"))
                    }
                    if(self.parques>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Parada, imagenPrincipal: UIImage(named: "parques_item")!, icono: UIImage(named: "parques_red")!, nombre: "Plazas y Parques", cantidad: "\(self.parques)"))
                    }
                    
                    if(self.religion>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Religion, imagenPrincipal: UIImage(named: "iglesia_item")!, icono: UIImage(named: "religion_red")!, nombre: "Iglesias", cantidad: "\(self.religion)"))
                    }
                    
                    if(self.salud>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Salud, imagenPrincipal: UIImage(named: "salud")!, icono: UIImage(named: "templos_red")!, nombre: "Salud", cantidad: "\(self.salud)"))
                    }
                    
                    if(self.educativos>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Educativos, imagenPrincipal: UIImage(named: "educativos_item")!, icono: UIImage(named: "academico_red")!, nombre: "Serv. Educativos", cantidad: "\(self.educativos)"))
                    }
                    
                    if(self.municipales>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Educativos, imagenPrincipal: UIImage(named: "municipales_item")!, icono: UIImage(named: "templos_red")!, nombre: "Serv. Municipales", cantidad: "\(self.municipales)"))
                    }
                    if(self.interes>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Interes, imagenPrincipal: UIImage(named: "entretenimiento_item")!, icono: UIImage(named: "cines_red")!, nombre: "Sitios de Interés", cantidad: "\(self.interes)"))
                    }
                    if(self.supermercados>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Supermercados, imagenPrincipal: UIImage(named: "selectos")!, icono: UIImage(named: "super_red")!, nombre: "Supermercados", cantidad: "\(self.supermercados)"))
                    }
                    if(self.tour>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Tour, imagenPrincipal: UIImage(named: "entretenimiento_item")!, icono: UIImage(named: "icono_360_red")!, nombre: "Tour", cantidad: "\(self.tour)"))
                    }
                    
                    
                    if(self.restaurantes>0){
                        misRecorridos.append(MiRecorrido(idMenu: self.Restaurantes, imagenPrincipal: UIImage(named: "restaurantes_item")!, icono: UIImage(named: "restaurantes_red")!, nombre: "Restaurantes", cantidad: "\(self.restaurantes)"))
                    }
                }
                
               
                
            }
            self.collectionViewRecorridos.reloadData()
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

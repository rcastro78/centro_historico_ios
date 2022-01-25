//
//  MapViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/2/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
class MapViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,GMSMapViewDelegate {
    var categorias = [Categoria]()
    
    
    
    
    var lugaresCategoria = [LugaresCategoria]()
    var lugares = [Lugar]()
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorias.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: categorias[row].name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
     }
     
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorias[row].term_id
       
   }

    @IBOutlet weak var btnBuscar: UIButton!
    @IBOutlet weak var txtBuscar: UITextField!
    @IBOutlet weak var mapa: GMSMapView!
    @IBOutlet weak var pickerCategoria: UIPickerView!
    
    override func viewDidDisappear(_:Bool){
        super.viewDidDisappear(true)
        self.lugares.removeAll()
        self.mapa.clear()
    }
    
    override func viewDidAppear(_:Bool){
        super.viewDidAppear(true)
        let filtrado = UserDefaults.standard.integer(forKey:"filtrado")
        print("cat: viewDidAppear")
        
        if(filtrado==0){
            let camera = GMSCameraPosition.camera(withLatitude: 13.6996502, longitude: -89.1925729, zoom: 16.0)
            mapa.animate(to: camera)
           
            let cat = UserDefaults.standard.string(forKey: "catName")!
            print("cat: \(cat)")
            print("cat: \(APPURL.URL_PRINCIPAL+RutasGET.LUGARES_CATEGORIA)")
            getLugaresCategoria(direccion: APPURL.URL_PRINCIPAL+RutasGET.LUGARES_CATEGORIA+"?cat=\(cat.replacingOccurrences(of: " ", with: "%20"))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapa.delegate = self
        self.hideKeyboardWhenTappedAround()
        let camera = GMSCameraPosition.camera(withLatitude: 13.6996502, longitude: -89.1925729, zoom: 16.0)
        mapa.animate(to: camera)
        // Do any additional setup after loading the view.
        if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
            getCategorias(direccion: APPURL.URL_PRINCIPAL+RutasGET.CATEGORIAS)
        }else{
            getCategorias(direccion: APPURL.URL_PRINCIPAL+RutasGET.CATEGORIES)
            txtBuscar.placeholder="Search for a place"
            btnBuscar.setTitle("Search", for: .normal)
        }
        self.pickerCategoria.dataSource=self
        self.pickerCategoria.delegate = self
       
        
    }
   
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let lat = Double(marker.position.latitude ?? 0)
        let lng = Double(marker.position.longitude ?? 0)
            print("InfoView tapped \(lat),\(lng)")
        
        UserDefaults.standard.setValue("\(lat)", forKey: "latLugar")
        UserDefaults.standard.setValue("\(lng)", forKey: "lngLugar")
        UserDefaults.standard.setValue(marker.title, forKey: "titulo")
        self.performSegue(withIdentifier: "mapaDetalleSegue", sender: self)
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cat  = categorias[row].name.replacingOccurrences(of: " ", with: "%20")
        UserDefaults.standard.setValue(categorias[row].term_id, forKey: "idCat")
        UserDefaults.standard.setValue(1,forKey:"filtrado")
        getLugaresCategoria(direccion: APPURL.URL_PRINCIPAL+RutasGET.LUGARES_CATEGORIA+"?cat=\(cat)")
    }
    
    
    @IBAction func buscar(_ sender: Any) {
        let lugarBuscar = self.txtBuscar.text!
        if(lugarBuscar != ""){
            getLugaresNombre(direccion: APPURL.URL_PRINCIPAL+RutasGET.LUGARES_NOMBRE+"?q=\(lugarBuscar)")
            print(APPURL.URL_PRINCIPAL+RutasGET.LUGARES_NOMBRE+"?q=\(lugarBuscar)")
        }else{
            if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                let refreshAlert = UIAlertController(title: "San Salvador Histórico", message: "No puedes buscar sin escribir algo", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .destructive, handler: { (action: UIAlertAction!) in
                    //self.dismiss(animated: true, completion: nil)
                }))

                present(refreshAlert, animated: true, completion: nil)
            }else{
                let refreshAlert = UIAlertController(title: "San Salvador Histórico", message: "You can't search without writing something", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Accept", style: .destructive, handler: { (action: UIAlertAction!) in
                    //self.dismiss(animated: true, completion: nil)
                }))

                present(refreshAlert, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func getCategorias(direccion:String){
        self.categorias.removeAll()
        
        AF.request(direccion, method: .get)
          .responseJSON { response in
              if response.data != nil {
                let json = try? JSON(data: response.data!)
                if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                    self.categorias.append(Categoria(term_id: "0", name: "Selecciona..."))
                }else{
                    self.categorias.append(Categoria(term_id: "0", name: "Select..."))
                }
                for i in 0 ... json!.count-1 {
                   
                    self.categorias.append(Categoria(term_id: json![i]["term_id"].stringValue, name: json![i]["name"].stringValue))
                }
              }
            self.pickerCategoria.reloadAllComponents()
          }
        
        
        
        /*let req = AF.request(direccion)
        req.responseJSON { (data) in
            var json = JSON(data)
            print(json["term_id"])
          }*/
        }
    
    
    func getLugaresNombre(direccion:String){
        self.lugares.removeAll()
        self.mapa.clear()
        AF.request(direccion, method: .get)
          .responseJSON { response in
              if response.data != nil {
                let json = try? JSON(data: response.data!)
                for i in 0 ... json!.count-1 {
                    let id = json![i]["id"].stringValue
                    let post_title = json![i]["post_title"].stringValue
                    let url = json![i]["url"].stringValue
                    let latitud = json![i]["latitud"].stringValue
                    let longitud = json![i]["longitud"].stringValue
                    print(id)
                    if(latitud != "" || longitud != ""){
                        let pos = CLLocationCoordinate2D(latitude: Double(latitud)!, longitude: Double(longitud)!)
                        let marker = GMSMarker(position: pos)
                    marker.icon = self.resizeImage(UIImage(named: "buscar_red")!, targetSize: CGSize(width: 32.0, height: 32.0))
                    marker.title = post_title
                        
                        if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                            marker.snippet = "VISITAR"
                        }else{
                            marker.snippet = "VISIT"
                        }
                    
                    marker.map = self.mapa
                    
                   
                    let camera = GMSCameraPosition.camera(withLatitude: Double(latitud)!, longitude: Double(longitud)!, zoom: 16.0)
                    self.mapa.animate(to: camera)
                    }
                    
                }
              }
          }
    }
    
    let Alojamiento=157;
    let Accommodation=535;
    let Bancos=69;
    let Banks=532;
    let Bares=197;
    let Bars=537;
    let Bibliotecas=468;
    let Libraries=547;
    let Comida=469;
    let Food=548;
    let Compras=470;
    let Shopping=549;
    let Instituciones=478;
    let Institutions=552;
    let Mercados=71;
    let Markets=533;
    let Museos=290;
    let Museums=539;
    let Otros=474;
    let Others=551;
    let Parada=223;
    let BusStations=538;
    let Parqueo=442;
    let Parking=541;
    let Religion=464;
    let ReligionEn=545;
    let Restaurantes=35;
    let Restaurants=531;
    let Parques=302;
    let Parks=540;
    let Salud=445;
    let Health=542;
    let Educativos=472;
    let Educational=550;
    let Municipales=452;
    let Municipal=544;
    let Interes=465;
    let Interest=546;
    let Emblematicos=183;
    let Emblematics=536;
    let Supermercados=145;
    let Supermarkets=534;
    let Tour=451;
    func getLugaresCategoria(direccion:String){
        self.lugaresCategoria.removeAll()
        self.mapa.clear()
       let dir = direccion.replacingOccurrences(of: "á", with: "a").replacingOccurrences(of: "é", with: "e").replacingOccurrences(of: "í", with: "i").replacingOccurrences(of: "ó", with: "o").replacingOccurrences(of: "ú", with: "u")
        print(dir)
        AF.request(dir, method: .get)
         .responseJSON { response in
              if response.data != nil {
                let json = try? JSON(data: response.data!)
                if(json!.count>0){
                    for i in 0 ... json!.count-1 {
                        let id = json![i]["id"].stringValue
                        let post_title = json![i]["post_title"].stringValue
                        let categoria = json![i]["categoria"].stringValue
                        let guid = json![i]["guid"].stringValue
                        let latitud = json![i]["latitud"].stringValue
                        let longitud = json![i]["longitud"].stringValue
                        let url = json![i]["url"].stringValue
                        let post_content = json![i]["post_content"].stringValue
                        print(categoria)
                        self.lugaresCategoria.append(LugaresCategoria(id: id, post_title: post_title, categoria: categoria, guid: guid, latitud: latitud, longitud: longitud, url: url, post_content: post_content))
                        if(latitud != "" || longitud != ""){
                            let pos = CLLocationCoordinate2D(latitude: Double(latitud)!, longitude: Double(longitud)!)
                            let marker = GMSMarker(position: pos)
                            let idCat = Int(id)
                            var named:String = ""
                            if(categoria.contains("Delegaciones") || categoria == "Police Stations")
                            {named="seguridad"}
                            if(categoria == "Entretenimiento" || categoria == "Entertainment")
                            {named="cines_red"}
                            if(categoria == "Estacionamientos" || categoria == "Parking")
                            {named="parqueos_red"}
                            if(categoria == "Sanitizadores" || categoria == "Sanitizers")
                            {named="sanit_red"}
                            if(categoria == "ATM" || categoria == "Cajero Automático")
                            {named="atm_red"}
                            if(idCat == self.Alojamiento || idCat == self.Accommodation)
                            {named="alojamiento_red"}
                            if(categoria == "Restaurantes" || categoria == "Restaurants")
                            {named="restaurantes_red.png"}
                            if(categoria == "Bancos"  || categoria == "Banks")
                            {named="bancos_red"}
                            if(categoria == "Bibliotecas"  || categoria == "Libraries")
                            {named="templos_2_red"}
                            if(categoria == "Comida rápida"  || categoria == "Fast Food")
                            {named="comida_rapida_red"}
                            if(categoria == "Compras"  || categoria == "Shopping")
                            {named="centros_com"}
                            if(categoria == "Instituciones"  || categoria == "Institutions")
                            {named="monumentos_red"}
                            if(categoria == "Museos"  || categoria == "Museums")
                            {named="cultura_red"}
                            if(categoria == "Mercados"  || categoria == "Markets")
                            {named="super_red"}
                            if(categoria == "Otros"  || categoria == "Others")
                            {named="buscar_red"}
                            if(categoria == "Parada de buses"  || categoria == "Bus Stations")
                            {named="parada.png"}
                            if(idCat==self.Religion || idCat==self.ReligionEn)
                            {named="religion_red"}
                            if(categoria == "Salud"  || categoria == "Health")
                            {named="templos_red"}
                            if(categoria == "Servicios Educativos"  || categoria == "Educational Services")
                            {named="academico_red"}
                            if(categoria == "Servicios Municipales" || categoria == "Municipal Services")
                            {named="templos_red.png"}
                            if(idCat==self.Interes || idCat==self.Interest)
                            {named="sitios_red"}
                            if(categoria == "Sitios Emblemáticos" || categoria == "Emblematic Sites")
                            {named="sitios_red.png"}
                            if(categoria == "Supermercados"  || categoria == "Supermarkets")
                            {named="super_red"}
                            if(idCat==self.Bars || idCat==self.Bares)
                            {named="bares_circ"}
                            if(idCat == self.Parks || idCat == self.Parques)
                            {named="parques_circ"}
                            //TODO: faltan algunos
                            if(!named.isEmpty){
                            marker.icon = self.resizeImage(UIImage(named: named)!, targetSize: CGSize(width: 48.0, height: 48.0))
                            }else{
                                marker.icon = self.resizeImage(UIImage(named: "buscar_red")!, targetSize: CGSize(width: 48.0, height: 48.0))
                            }
                            marker.title = post_title
                            if (LocalizationSystem.sharedInstance.getLanguage() == "es") {
                            marker.snippet = "VISITAR"
                            }else{
                                marker.snippet = "VISIT"
                            }
                            
                            marker.map = self.mapa
                            
                           
                            
                            let camera = GMSCameraPosition.camera(withLatitude: Double(latitud)!, longitude: Double(longitud)!, zoom: 16.0)
                            self.mapa.animate(to: camera)
                        }
                }
                
                    
                    
                    
                }
              }
            
            
            
          }
        
        
        
        /*let req = AF.request(direccion)
        req.responseJSON { (data) in
            var json = JSON(data)
            print(json["term_id"])
          }*/
        }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
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

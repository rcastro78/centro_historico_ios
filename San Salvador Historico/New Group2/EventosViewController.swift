//
//  EventosViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/6/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
   
    
    var eventos = [Evento]()
    var buscando:Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var barBuscar: UISearchBar!
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(barBuscar.text?.isEmpty)!){
            buscando=true
            print("Buscar")
            eventos = eventos.filter({$0.post_title.lowercased().contains(searchBar.text!.lowercased())})
            self.tableViewEventos?.reloadData()
        }else{
            buscando=false
            view.endEditing(true)
            self.tableViewEventos?.reloadData()
        }
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        if searchBar.text==nil || searchBar.text==""{
            buscando=false
            view.endEditing(true)
            let direccion = APPURL.URL_PRINCIPAL+RutasGET.EVENTOS
            getEventos(direccion: direccion)
        }else{
            buscando=true
             print("Buscar")
            eventos = eventos.filter({$0.post_title.lowercased().contains(searchBar.text!.lowercased())})
            self.tableViewEventos?.reloadData()
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            as! EventoTableViewCell
        let evt = eventos[indexPath.row]
        cell.lblEvento.text = evt.post_title
        let url = URL(string:evt.guid)
        cell.imgEvento.layer.cornerRadius = 41.0
        cell.imgEvento.cargar(url: url!)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let evt = eventos[indexPath.row]
        
        UserDefaults.standard.setValue(evt.guid, forKey: "guid")
        UserDefaults.standard.setValue(evt.post_id, forKey: "post_id")
        UserDefaults.standard.setValue(evt.post_name, forKey: "post_name")
        UserDefaults.standard.setValue(evt.post_title, forKey: "post_title")
        UserDefaults.standard.setValue(evt.post_content , forKey: "post_content")
        performSegue(withIdentifier: "eventoSegue", sender: self)
    }
    
    
    @IBOutlet weak var tableViewEventos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.barBuscar.delegate=self
        let direccion = APPURL.URL_PRINCIPAL+RutasGET.EVENTOS
        getEventos(direccion: direccion)
      
        // Do any additional setup after loading the view.
    }
    
    
    func getEventos(direccion:String){
        self.eventos.removeAll()
        
        AF.request(direccion, method: .get)
          .responseJSON { response in
              if response.data != nil {
                let json = try? JSON(data: response.data!)
                
                for i in 0 ... json!.count-1 {
                    let id = json![i]["id"].stringValue
                    let post_id = json![i]["ID"].stringValue
                    let post_title = json![i]["post_title"].stringValue
                    let post_name = json![i]["post_name"].stringValue
                    let post_content = json![i]["post_content"].stringValue
                    let post_parent = json![i]["post_parent"].stringValue
                    let guid = json![i]["guid"].stringValue
                    self.eventos.append(Evento(id: id, post_id: post_id, post_name: post_name, post_title: post_title, post_content: post_content, post_parent: post_parent, guid: guid))
                }
                
                OperationQueue.main.addOperation {
                    
                    self.tableViewEventos.reloadData();
                }
                
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

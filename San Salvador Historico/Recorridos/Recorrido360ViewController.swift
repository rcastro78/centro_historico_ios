//
//  Recorrido360ViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/5/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import Lottie
class Recorrido360ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var videos = [Video]()
    
    

    @IBOutlet weak var tableViewRecorridos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         mostrarVideos()
        self.tableViewRecorridos.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        UserDefaults.standard.setValue(video.videoUrl, forKey: "videoUrl")
        self.performSegue(withIdentifier: "videoSegue", sender: self)
    }
    
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
            as! Recorrido360TableViewCell
            let r = videos[indexPath.row]
            cell.lblItem.text? = r.textoVideo
            /*cell.icono!.loopMode = .loop
            cell.icono!.animationSpeed = 0.5
            cell.icono!.play()*/
            cell.imgVideo.image = r.foto
            
            return cell
            
            
            
    }
    
    
    
    func mostrarVideos(){
        self.videos.append(Video(idVideo: 1, videoUrl: "https://my.matterport.com/show/?m=MdURrp2Xx8z", textoVideo: "Museo de la Moneda",foto: UIImage(named:"museo_moneda")!))
        self.videos.append(Video(idVideo: 2, videoUrl: "https://my.matterport.com/show/?m=mrWoZNaA5Ro", textoVideo: "Parroquia Ma. Auxiliadora Don Rúa",foto: UIImage(named:"don_rua")!))
        self.videos.append(Video(idVideo: 3, videoUrl: "https://my.matterport.com/show/?m=gPo3XRi7Kbj", textoVideo: "Plaza Cap. Gral. Gerardo Barrios",foto: UIImage(named:"gerardo_barrios")!))
        self.videos.append(Video(idVideo: 4, videoUrl: "https://my.matterport.com/show/?m=hJNotvJbjwd", textoVideo: "Iglesia El Rosario",foto: UIImage(named:"el_rosario")!))
        self.videos.append(Video(idVideo: 5, videoUrl: "https://my.matterport.com/models/i51Y7kmsmDz", textoVideo: "Plaza Francisco Morazán",foto: UIImage(named:"plaza_morazan")!))
        self.videos.append(Video(idVideo: 6, videoUrl: "https://my.matterport.com/models/namQBta6kmu", textoVideo: "Museo de la Moneda",foto: UIImage(named:"museo_moneda")!))
        self.videos.append(Video(idVideo: 7, videoUrl: "https://my.matterport.com/models/qhEFCyA2kqf", textoVideo: "Catedral Metropolitana de San Salvador",foto: UIImage(named:"catedral")!))
        self.videos.append(Video(idVideo: 8, videoUrl: "https://my.matterport.com/show/?m=NmHVNDuefMX", textoVideo: "Plaza Libertad",foto: UIImage(named:"plaza_libertad")!))
        
        self.videos.append(Video(idVideo: 9, videoUrl: "https://youtu.be/eKovdv2srnY", textoVideo: "Caminata Nocturna",foto: UIImage(named:"caminata_nocturna")!))
        
        self.videos.append(Video(idVideo: 10, videoUrl: "https://youtu.be/x4D_Sg8w3_Y", textoVideo: "Parque Cuscatlán",foto: UIImage(named:"parque_cuscatlan")!))
        
    }

    /*
     private void mostrarVideos(ListView lstVideos){
             items.add(new Video(1,"https://my.matterport.com/show/?m=MdURrp2Xx8z","Museo de la Moneda"));
             items.add(new Video(2,"https://my.matterport.com/show/?m=mrWoZNaA5Ro ","Parroquia Ma. Auxiliadora Don Rua"));
             items.add(new Video(3,"https://my.matterport.com/show/?m=gPo3XRi7Kbj","Plaza Cap. Gral. Gerardo Barrios"));
             items.add(new Video(4,"https://my.matterport.com/show/?m=hJNotvJbjwd","Iglesia el Rosario"));
             items.add(new Video(5,"https://my.matterport.com/models/i51Y7kmsmDz","Plaza Francisco Morazán"));
             items.add(new Video(6,"https://my.matterport.com/models/namQBta6kmu","Catedral Metropolitana de San Salvador"));
             items.add(new Video(7,"https://my.matterport.com/models/qhEFCyA2kqf","Cementerio General Los Ilustres"));
             items.add(new Video(8,"https://my.matterport.com/show/?m=NmHVNDuefMX","Plaza Libertad"));
             videoAdapter = new VideoAdapter(RecorridosActivity.this,items);
             lstVideos.setAdapter(videoAdapter);
         }
     */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

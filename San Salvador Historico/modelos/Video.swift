//
//  Video.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/5/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class Video: NSObject {
    var idVideo:Int=0
    var videoUrl:String=""
    var textoVideo:String=""
    var foto:UIImage
    init(idVideo:Int,videoUrl:String,textoVideo:String,foto:UIImage) {
        self.idVideo = idVideo
        self.videoUrl = videoUrl
        self.textoVideo = textoVideo
        self.foto = foto
    }
    
    
}

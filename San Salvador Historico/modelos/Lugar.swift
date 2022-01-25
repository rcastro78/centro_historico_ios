//
//  Lugar.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/3/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
//private String id,post_title,url,post_type,thumbnail,longitud,latitud,tipo;
class Lugar: NSObject {
    var id:String
    var post_title:String
    var url:String
    var post_type:String
    var thumbnail:String
    var longitud:String
    var latitud:String
    var tipo:String
    var language_code:String
    init(id:String,post_title:String,url:String,post_type:String,thumbnail:String,longitud:String,latitud:String,tipo:String,language_code:String){
        self.id = id
        self.url = url
        self.post_title=post_title
        self.post_type=post_type
        self.thumbnail = thumbnail
        self.longitud = longitud
        self.latitud = latitud
        self.tipo = tipo
        self.language_code = language_code
        
    }
    
}

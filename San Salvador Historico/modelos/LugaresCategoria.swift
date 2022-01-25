//
//  LugaresCategoria.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/4/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class LugaresCategoria: NSObject {
    
    var id:String
    var post_title:String
    var categoria:String
    var guid:String
    var latitud:String
    var longitud:String
    var url:String
    var post_content:String
    
    init(id:String,post_title:String,categoria:String,guid:String,latitud:String,longitud:String,url:String,post_content:String) {
        self.id = id
        self.post_title = post_title
        self.categoria = categoria
        self.guid = guid
        self.latitud = latitud
        self.longitud = longitud
        self.url = url
        self.post_content = post_content
    }
    
    
    
    
/*
     private String id;
       private String post_title;
       private String categoria;
       private String guid;
       private String latitud;
       private String longitud;
       private String url;
       private String post_content;
     */
}

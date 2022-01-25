//
//  Evento.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/6/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class Evento: NSObject {
    var id:String=""
    var post_id:String=""
    var post_name:String=""
    var post_title:String=""
    var post_content:String=""
    var post_parent:String=""
    var guid:String=""
    
    init(id:String,post_id:String,post_name:String,post_title:String,post_content:String,post_parent:String,guid:String){
        self.id = id
        self.post_id = post_id
        self.post_name = post_name
        self.post_title = post_title
        self.post_content = post_content
        self.post_parent = post_parent
        self.guid = guid
    }
    
}

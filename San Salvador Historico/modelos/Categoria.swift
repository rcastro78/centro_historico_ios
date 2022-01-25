//
//  Categoria.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/3/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class Categoria: NSObject {
    var term_id:String
    var name:String
    
    init(term_id:String,name:String){
        self.term_id = term_id
        self.name = name
    }
    
}

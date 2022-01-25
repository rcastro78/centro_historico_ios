//
//  MenuPerfil.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class MenuPerfil: NSObject {
    var idMenu:Int=0
    var textoMenu:String=""
    var imgMenu:UIImage
    
    init(idMenu:Int,imgMenu:UIImage,textoMenu:String){
        self.idMenu = idMenu
        self.imgMenu = imgMenu
        self.textoMenu = textoMenu
        
    }
}

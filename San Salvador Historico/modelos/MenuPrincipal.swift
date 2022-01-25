//
//  MenuPrincipal.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 1/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class MenuPrincipal: NSObject {
    var id:Int
    var imagen:UIImage
    var texto:String
    var color:UIColor
    
    init(id:Int,imagen:UIImage,texto:String,color:UIColor){
        self.id=id
        self.imagen=imagen
        self.texto=texto
        self.color=color
    }
    
}

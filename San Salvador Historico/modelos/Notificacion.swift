//
//  Notificacion.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/11/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class Notificacion: NSObject {
    var id:String
    var titulo:String
    var texto:String
    var fecha:String
    var foto:String
    
    init(id:String,titulo:String,texto:String,fecha:String,foto:String) {
        self.id = id
        self.titulo = titulo
        self.texto = texto
        self.fecha = fecha
        self.foto = foto
    }
    
}

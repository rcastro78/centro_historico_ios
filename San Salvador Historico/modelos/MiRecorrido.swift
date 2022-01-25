//
//  MiRecorrido.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/9/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit

class MiRecorrido: NSObject {
    var idMenu:Int=0
    var imagenPrincipal:UIImage
    var icono:UIImage
    var nombre:String=""
    var cantidad:String=""
    
    init(idMenu:Int,imagenPrincipal:UIImage,icono:UIImage,nombre:String,cantidad:String){
        self.idMenu = idMenu
        self.imagenPrincipal = imagenPrincipal
        self.icono = icono
        self.nombre = nombre
        self.cantidad = cantidad
    }
    
    
/*
     private int idMenu,imagenPrincipal,icono;
         private String nombre,cantidad;
     */
}

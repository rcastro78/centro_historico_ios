//
//  Constantes.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/3/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import Foundation

struct _APP{
    static let DB_NAME="sshistorico.sqlite"
}

struct APPURL{
    static let URL_PRINCIPAL = "https://www.sansalvadorhistorico.com/app/"
}

struct RutasGET {
    static let CATEGORIAS = "getCategorias.php"
    static let CATEGORIES = "getCategories.php"
    static let LUGARES_CATEGORIA = "getLugaresCategoriaUrl.php"
    static let LUGARES_NOMBRE = "getLugaresPorNombre.php"
    static let LUGAR_FOTO = "getLugarFoto3.php"
    static let LUGARES_COORDENADAS = "getLugarCoordenadasFoto.php"
    static let EVENTOS = "getEventos.php"
    static let POST_CONTENT = "getPostContentTempB.php"
}

//
//  Electrodomestico.swift
//  MultiTabApp
//
//  Created by Pedro Herrera on 07/02/2018.
//  Copyright © 2018 Pedro Herrera. All rights reserved.
//

import UIKit

class Electrodomestico: NSObject {
    var id: Int
    var descripcion: String
    var precio: Int
    
    override init() {
        self.id = -1
        self.descripcion = ""
        self.precio = -1
    }
    
    init(id: Int, descripcion: String, precio: Int)
    {
        self.id = id
        self.descripcion = descripcion
        self.precio = precio
    }
}

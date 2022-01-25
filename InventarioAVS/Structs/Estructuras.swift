//
//  Estructuras.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import Foundation


struct Device: Codable {
    let ID: Int
    let codigo, producto, marca, fecha: String
    let modelo, foto, cantidad, observaciones: String
    let IDlugar: Int
    let pertenece, descompostura, costo, compra: String
    let serie, proveedor, lugar, origen: String
}

typealias Devices = [Device]

struct User: Codable {
    let ID: Int
    let nombre, apellido_paterno, apellido_materno, IDuser: String?
    let password, tipousuario, fecha, telefono: String?
    let IDtipoUsuario, statuscode: Int?
    let correo, rol, message, foto: String?
}

typealias Users = [User]

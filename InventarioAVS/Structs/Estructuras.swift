//
//  Estructuras.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import Foundation


struct Device: Codable {
    let id, cantidad, costo: Int
    let codigo, producto, marca, fechaAlta: String
    let modelo, foto, observaciones: String?
    let lugarId: Int
    let pertenece, descompostura, compra: String?
    let serie, proveedor, origen: String?
}

struct DeviceResponse : Codable
{
    let app_code : String
    let data : [Device]
}
struct UserRespose: Codable {
    let app_code : String
    let data : [loginUser]
}

struct loginUser : Codable
{
    let apellidoMaterno : String
    let apellidoPaterno : String
    let correo : String
    let fechaAlta : String
    let fechaUltimaModificacion : String
    let foto : String
    let id : Int
    let nombre : String
    let rolId : Int
    let telefono : String
    let username : String
    let rol : Rol
}
struct Rol : Codable
{
    let id : Int
    let nombre : String
}


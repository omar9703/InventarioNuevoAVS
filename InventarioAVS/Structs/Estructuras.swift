//
//  Estructuras.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import Foundation


struct Device: Codable {
    let id, cantidad, costo: Int?
    let codigo, producto, marca, fechaAlta: String?
    let modelo, foto, observaciones: String?
    let lugarId: Int?
    let pertenece, descompostura, compra: String?
    let serie, proveedor, origen: String?
    let lugar : Lugar?
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

struct filterResponse : Codable
{
    let app_code : String
    let data : [products]
    let total_rows : Int?
}

struct products : Codable
{
    let codigo , descripcion, lugar , marca , modelo, producto, serie : String?
    let id : Int
}


struct loginUser : Codable
{
    let apellidoMaterno : String
    let apellidoPaterno : String
    let correo : String
    let fechaAlta : String
    let fechaUltimaModificacion : String
    let foto : String?
    let id : Int
    let nombre : String
    let rolId : Int
    let telefono : String
    let username : String
    let rol : RolUser
}
struct RolUser : Codable
{
    let id : Int
    let nombre : String
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Reportes: Codable {
    let appCode: String
        let data: [Datum]
        let message: [Message]

        enum CodingKeys: String, CodingKey {
            case appCode = "app_code"
            case data, message
        }
}

// MARK: - Datum
struct Datum: Codable {
    let comentarios: String?
    let dispositivo: Dispositivo
    let dispositivoId: Int
    let fechaAlta, fechaUltimaModificacion: String
    let foto: Foto?
    let id: Int
    let usuario: Usuarios
    let usuarioId: Int

}

// MARK: - Dispositivo
struct Dispositivo: Codable {
    let accesorios: String?
    let cantidad: Int?
    let codigo, compra: String?
    let costo: Int?
    let descompostura, fechaAlta, fechaUltimaModificacion: String?
    let foto: Foto?
    let id: Int
    let idMov: Int?
    let lugar: Lugar?
    let lugarId: Int?
    let marca, modelo, observaciones, origen: String?
    let pertenece, producto, proveedor, serie: String?
    let status: Status?
    let statusId: Int?

}

enum Foto: String, Codable {
    case operacion = "Operacion"
    case string = "string"
}

struct Lugar: Codable {
    let activo: Bool?
    let fechaAlta, fechaUltimaModificacion: String?
    let id: Int
    let lugar: String?
}

// MARK: - Status
struct Status: Codable {
    let descripcion: String?
    let fechaAlta, fechaUltimaModificacion: String
    let id: Int
    let nombre: String?
}



// MARK: - Usuario
struct Usuarios: Codable {
    let apellidoMaterno, apellidoPaterno, correo, fechaAlta: String
        let fechaUltimaModificacion: String
        let foto: Foto?
        let id: Int
        let nombre: String
        let rol: Status
        let rolID: Int
        let status: Status
        let statusID: Int
        let telefono, username: String

        enum CodingKeys: String, CodingKey {
            case apellidoMaterno, apellidoPaterno, correo, fechaAlta, fechaUltimaModificacion, foto, id, nombre, rol
            case rolID = "rolId"
            case status
            case statusID = "statusId"
            case telefono, username
        }
}

// MARK: - Message
struct Message: Codable {
    let status: String
}

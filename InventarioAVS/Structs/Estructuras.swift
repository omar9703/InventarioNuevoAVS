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
    let dispositivoID: Int
    let fechaAlta, fechaUltimaModificacion: String
    let foto: Foto?
    let id: Int
    let usuario: Usuarios
    let usuarioID: Int

    enum CodingKeys: String, CodingKey {
        case comentarios, dispositivo
        case dispositivoID = "dispositivoId"
        case fechaAlta, fechaUltimaModificacion, foto, id, usuario
        case usuarioID = "usuarioId"
    }
}

// MARK: - Dispositivo
struct Dispositivo: Codable {
    let cantidad: Int
    let codigo, compra: String
    let costo: Int
    let descompostura, fechaAlta, fechaUltimaModificacion: String
    let foto: Foto?
    let id: Int
    let idMOV: Foto?
    let lugar: Lugar
    let lugarID: Int
    let marca, modelo, observaciones: String
    let origen, pertenece: Foto?
    let producto, proveedor: String
    let status: Status
    let statusID: Int

    enum CodingKeys: String, CodingKey {
        case cantidad, codigo, compra, costo, descompostura, fechaAlta, fechaUltimaModificacion, foto, id
        case idMOV = "idMov"
        case lugar
        case lugarID = "lugarId"
        case marca, modelo, observaciones, origen, pertenece, producto, proveedor, status
        case statusID = "statusId"
    }
}

enum Foto: String, Codable {
    case operacion = "Operacion"
    case string = "string"
}

// MARK: - Lugar
struct Lugar: Codable {
    let activo: Bool
    let fechaAlta, fechaUltimaModificacion: String
    let id: Int
    let lugar: String
}

// MARK: - Status
struct Status: Codable {
    let descripcion: String?
    let fechaAlta: String
    let fechaUltimaModificacion: String
    let id: Int
    let nombre: String?
}



// MARK: - Usuario
struct Usuarios: Codable {
    let apellidoMaterno, apellidoPaterno, correo: Foto
    let fechaAlta, fechaUltimaModificacion: String
    let foto: Foto
    let id: Int
    let nombre: String
    let rol: Status
    let rolID: Int
    let status: Status
    let statusID: Int
    let telefono: Foto
    let username: String

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

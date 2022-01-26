//
//  MenuItems.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 26/01/22.
//

import Foundation

class MenuItems {
    public static let MenuAdmin : [MenuItem] = [MenuItem(nombre: "profile", tipoUsuario: 5, imagen: "PERFIL", route: "",storyboard: ""),
        MenuItem(nombre: "inventario", tipoUsuario: 5, imagen: "INVENTARIO", route: "productsController",storyboard: "Products"),
        MenuItem(nombre: "historial", tipoUsuario: 5, imagen: "HISTORIAL", route: "",storyboard: ""),
        MenuItem(nombre: "empleados", tipoUsuario: 5, imagen: "EMPLEADOS", route: "",storyboard: ""),
        MenuItem(nombre: "reporte", tipoUsuario: 5, imagen: "REPORTE",route: "",storyboard: ""),
        MenuItem(nombre: "settings", tipoUsuario: 5, imagen: "ajustes",route: "",storyboard: "")]
}

struct MenuItem {
    let nombre : String
    let tipoUsuario : Int
    let imagen : String
    let route : String
    let storyboard : String
}

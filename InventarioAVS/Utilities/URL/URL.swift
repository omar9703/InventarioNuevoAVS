//
//  URL.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import Foundation

let urlBase = "https://avsinvservice.azurewebsites.net/"

public class urlAVSdevice
{
        public static let devices = urlBase + "devices"
        public static let deviceId = urlBase + "deviceid/"
}

public class urlAVSuser
{
    public static let users = urlBase + "users"
}

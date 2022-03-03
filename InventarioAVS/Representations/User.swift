//
//  User.swift
//  InventarioAVS
//
//  Created by Omar Campos on 03/03/22.
//

import Foundation
import UIKit
import CoreData

class UsuarioData {
    public static func SaveUser(user: loginUser) {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "Usuario",
                                     in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
          person.setValue(user.nombre, forKeyPath: "nombre")
          person.setValue(user.apellidoMaterno, forKey: "apellidoMaterno")
        person.setValue(user.apellidoPaterno, forKey: "apellidoPaterno")
        person.setValue(user.telefono, forKey: "telefono")
        person.setValue(user.correo, forKey: "correo")
        print(user)
        
        // 4
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    public static func GetUser() -> loginUser?
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return nil
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Usuario")
          
          //3
          do {
              let usuario = try managedContext.fetch(fetchRequest).last
              if let usuario = usuario
              {
                  let userd = loginUser(apellidoMaterno: usuario.value(forKey: "apellidoMaterno") as! String, apellidoPaterno: usuario.value(forKey: "apellidoPaterno") as! String, correo: usuario.value(forKey: "correo") as! String, fechaAlta: "", fechaUltimaModificacion: "", foto: "", id: 0, nombre: usuario.value(forKey: "nombre") as! String, rolId: 0, telefono: usuario.value(forKey: "telefono") as! String, username: "", rol: Rol(id: 1, nombre: "Administrador"))
                  return userd
              }
              else
              {
                  return nil
              }
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
              return nil
          }
    }
    
    public static func deleteUser()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Usuario")
        do
        {
            let array = try managedContext.fetch(fetchRequest)
            for object in array
            {
                managedContext.delete(object)
                appDelegate.saveContext()
            }
        }
        catch
        {
            
        }
    }
    
}

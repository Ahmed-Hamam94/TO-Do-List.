//
//  CoreData.swift
//  CoreList
//
//  Created by Ahmed Hamam on 18/02/2023.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataProtocol{
    func saveItem(name:String, tableView : UITableView)
    func getItem()
    func deleteItem(item:ToDoListItem, tableView : UITableView)
    func editItem(item:ToDoListItem, newName:String, tableView : UITableView)
    var arrItem : [ToDoListItem] {get set}
}

class CoreData : CoreDataProtocol{
    
    let appdelegat = UIApplication.shared.delegate as! AppDelegate
    var viewContext : NSManagedObjectContext?
    var arrItem = [ToDoListItem]()
    var tableView : UITableView?
    init(){
       
        viewContext  = appdelegat.persistentContainer.viewContext

    }
    
    func saveItem(name:String, tableView : UITableView){
        guard let viewContext = viewContext else{return}
        let newItem = ToDoListItem(context: viewContext)
        newItem.name = name
        newItem.createdAt = Date()
        appdelegat.saveContext()
        getItem()
        tableView.reloadData()
    }
    //###################################
    func getItem(){
        guard let viewContext = viewContext else{return}
        do{
            arrItem = try viewContext.fetch(ToDoListItem.fetchRequest())
           // tableView.reloadData()
        }catch{
            print(error)
        }
    }
    //######################################
    func deleteItem(item:ToDoListItem, tableView : UITableView){
        viewContext?.delete(item)
        do{
           try viewContext?.save()
            getItem()
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
    //#################################
    func editItem(item:ToDoListItem, newName:String, tableView : UITableView){
        item.name = newName
        appdelegat.saveContext()
        getItem()
        tableView.reloadData()
    }
}

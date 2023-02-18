//
//  ViewController.swift
//  CoreList
//
//  Created by Ahmed Hamam on 11/12/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    let appdelegat = UIApplication.shared.delegate as! AppDelegate
    var viewContext : NSManagedObjectContext?
    private var arrItem = [ToDoListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = appdelegat.persistentContainer.viewContext
        getItem()
        setUpTable()
    }
    
    func setUpTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .lightGray
    }
    //###############################
    func saveItem(name:String){
        guard let viewContext = viewContext else{return}
        let newItem = ToDoListItem(context: viewContext)
        newItem.name = name
        newItem.createdAt = Date()
        appdelegat.saveContext()
        getItem()
    }
    //###################################
    func getItem(){
        guard let viewContext = viewContext else{return}
        do{
            arrItem = try viewContext.fetch(ToDoListItem.fetchRequest())
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
    //######################################
    func deleteItem(item:ToDoListItem){
        viewContext?.delete(item)
        do{
           try viewContext?.save()
            getItem()
        }catch{
            print(error)
        }
    }
    //#################################
    func editItem(item:ToDoListItem, newName:String){
        item.name = newName
        appdelegat.saveContext()
        getItem()
    }
    //#################################
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter New Item"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default,handler: { [weak self]_ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{return}
          
            self?.saveItem(name: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func editButton(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrItem.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.00
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
               headerView.backgroundColor = UIColor.clear
               return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itm = arrItem[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListTableViewCell
       // cell.itemToDoLbl.text = "  \(itm.name ?? "")"
       cell.textLabel?.text = "  \(itm.name ?? "")"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .italicSystemFont(ofSize: 23)
        cell.textLabel?.textColor     = UIColor.black
        cell.textLabel?.textAlignment = .center
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 1
        
        
        
        cell.backgroundColor = .black
        cell.layer.cornerRadius = cell.frame.size.width / 7
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOpacity = 0.9
        cell.layer.shadowOffset = .zero
        cell.layer.shadowRadius = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let itm = arrItem[indexPath.section]

        let sheet = UIAlertController(title: "Created At", message: "\(itm.createdAt!.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: .omitted))", preferredStyle: .alert)
        sheet.addTextField(configurationHandler: nil)
        sheet.textFields?.first?.text = itm.name
        sheet.addAction(UIAlertAction(title: "OK", style: .cancel,handler: { [weak self]_ in
            guard let field = sheet.textFields?.first, let newName = field.text, !newName.isEmpty else{return}
            self?.editItem(item: itm, newName: newName)
        }))


        present(sheet, animated: true)
   
        
     
       
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          if(indexPath.section % 2 == 0) {
           
              cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.02)
          } else {
              cell.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
          
          }
      }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        arrItem.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            self.deleteItem(item: self.arrItem[indexPath.section])

            completionHandler(true)
        }
      
        delete.image = UIImage(systemName: "trash")
      
    
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    }



import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [CateGory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Category"
        
        loadCategory()
    }
    
    @IBAction func addButtonPrssed(_ sender: UIBarButtonItem) {
        
        var categoryUITextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCateogry = CateGory(context: self.context)
            newCateogry.name = categoryUITextField.text!
            
            self.categoryArray.append(newCateogry)
            
            self.saveCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            categoryUITextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryList", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        cell.textLabel?.textColor = .blue
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods

    
    func saveCategory() {
        do {
            try context.save()
        }catch {
            print("Error saving category \(error)")
        }
    
        tableView.reloadData()
    }
    
    func loadCategory(_ request: NSFetchRequest<CateGory> = CateGory.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Error fetching data from context of category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodolistViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { action, view, complete in
            
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            
            self.saveCategory()
            complete(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
 




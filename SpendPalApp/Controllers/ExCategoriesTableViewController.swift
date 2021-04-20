//
//  ViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-17.
//

import UIKit
import CoreData

class ExCategoriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var buttonAddExpenseCategory: UIBarButtonItem!
    var expensesViewController: ExpensesViewController? = nil
    @IBOutlet weak var buttonProfile: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        // TODO - buttonProfile.text = PROFILE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func buttonOrganizePressed(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
    }
    
    
    @IBAction func longPressedCell(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            isEditing = !isEditing
        }
    }
    @IBAction func tappedCell(_ sender: UITapGestureRecognizer) {
        if isEditing{
            isEditing = false
        }
    }
    
    @objc
    func addNewExCategory(_ sender: Any) {
        let appContext = self._appFetchedResultsController?.managedObjectContext
        let newExCategory = Category(context: appContext!)
             
        newExCategory.profile="Profile_0" // TODO: Add Multiple Profiles Support
        newExCategory.name="Test: \(Date())"
        //newExCategory.

        do {
            try appContext!.save()
        } catch {

            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    
    // MARK: - Expenses Category Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return exCategoryFetchResController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = exCategoryFetchResController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cusCell = tableView.dequeueReusableCell(withIdentifier: "cusCellExCategory", for: indexPath) as? ExCategoryTableViewCell else {fatalError("Cell Buid Error")}
        let category = exCategoryFetchResController.object(at: indexPath)
        buildExCategoryCell(cusCell, withExCategory: category)
        let cusCellBackView = UIView()
        cusCellBackView.backgroundColor = SpendAppUtils.getCodeColour("SELECTED")
        cusCell.selectedBackgroundView = cusCellBackView
        cusCellBackView.layer.cornerRadius = 8
        cusCell.layer.cornerRadius = 8
        return cusCell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let objContext = exCategoryFetchResController.managedObjectContext
            objContext.delete(exCategoryFetchResController.object(at: indexPath))
            
            do {
                try objContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }

    func buildExCategoryCell(_ cusCell: ExCategoryTableViewCell, withExCategory category: Category) {
        cusCell.textLabelExCategoryName.text = category.name
        cusCell.textLabelBudgetAmount.text =  "\(category.monthlyBudget?.decimalValue ?? 0.0)"
        cusCell.textLabelNotes.text = category.notes
        cusCell.backgroundColor = SpendAppUtils.getCodeColour(category.colour ?? "DEFUALT")
        
    }

    
    // MARK: - Expense Category Fet. Res. Controller

    var exCategoryFetchResController: NSFetchedResultsController<Category> {
        if _appFetchedResultsController != nil {
            return _appFetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Batch size
        fetchRequest.fetchBatchSize = 20
        
        // Sorting; There's no ordering in CoreData. Hence SortDescriptor is what creates the order
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SpendAppUtils.managedAppObjContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _appFetchedResultsController = aFetchedResultsController
        
        do {
            try _appFetchedResultsController!.performFetch()
        } catch {
             let nserror = error as NSError
             fatalError("Unable to Fetch Data \(nserror), \(nserror.userInfo)")
        }
        
        return _appFetchedResultsController!
    }
    
    var _appFetchedResultsController: NSFetchedResultsController<Category>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                buildExCategoryCell(tableView.cellForRow(at: indexPath!)! as! ExCategoryTableViewCell, withExCategory: anObject as! Category)
            case .move:
                buildExCategoryCell(tableView.cellForRow(at: indexPath!)! as! ExCategoryTableViewCell, withExCategory: anObject as! Category)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
            default:
                return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Navigation Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            case "toExpensesDetails":
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    let selectedObj = exCategoryFetchResController.object(at: selectedIndex)
                    let expensesVC = (segue.destination as! UINavigationController).topViewController as! ExpensesViewController
                    expensesVC.expenseCategory = selectedObj
//                    expensesVC.navigationItem.backBarButtonItem = splitViewController?.displayModeButtonItem
//                    expensesVC.navigationItem.leftItemsSupplementBackButton = true
                    expensesViewController = expensesVC
                }
            default:
                break
            }
             
        }
    }



}

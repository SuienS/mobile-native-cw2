/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: TableViewController for Categories
 */
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
    @IBOutlet weak var barButtonEditCategory: UIBarButtonItem!
    
    
    // Sort Descriptors
    let sortDescriptorName = NSSortDescriptor(key: "name", ascending: true)
    let sortDescriptorMonBudget = NSSortDescriptor(key: "monthlyBudget", ascending: false)
    let sortDescriptorClickFrequency = NSSortDescriptor(key: "clickFrequency", ascending: false)
    // Default Sort Descriptor
    var sortDescriptor = NSSortDescriptor(key: "clickFrequency", ascending: false)
    
    // Fetched Results
    var fetchedResultsCategory: NSFetchedResultsController<Category> = NSFetchedResultsController<Category>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        sortDescriptor = sortDescriptorClickFrequency
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        sortDescriptor = sortDescriptorClickFrequency
        fetchedResultsCategory = fetchResultsCategory(sortWith: sortDescriptor)
    }
    
    // MARK: - Action Handles
    
    // Long Press edit
    @IBAction func longPressedCell(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            isEditing = !isEditing
            barButtonEditCategory.isEnabled = false
        }
    }
    
    // A-Z Sort
    @IBAction func barButtonPresedSortAZ(_ sender: UIBarButtonItem) {
        sortDescriptor = sortDescriptorName
        fetchedResultsCategory = fetchResultsCategory(sortWith: sortDescriptor)
        tableView.reloadData()
        barButtonEditCategory.isEnabled = false
    }
    
    // Budget Sort
    @IBAction func barButtonPressedSortBudget(_ sender: UIBarButtonItem) {
        sortDescriptor = sortDescriptorMonBudget
        fetchedResultsCategory = fetchResultsCategory(sortWith: sortDescriptor)
        tableView.reloadData()
        barButtonEditCategory.isEnabled = false
    }
    
    // Sort Reset; Budget sort
    @IBAction func barButtonPressedSortDefault(_ sender: UIBarButtonItem) {
        sortDescriptor = sortDescriptorClickFrequency
        fetchedResultsCategory = fetchResultsCategory(sortWith: sortDescriptor)
        tableView.reloadData()
        barButtonEditCategory.isEnabled = false
    }
    
    
    
    
    // MARK: - Expenses Category Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsCategory.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsCategory.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cusCell = tableView.dequeueReusableCell(withIdentifier: "cusCellExCategory", for: indexPath) as? ExCategoryTableViewCell else {fatalError("Cell Buid Error")}
        let category = fetchedResultsCategory.object(at: indexPath)
        buildExCategoryCell(cusCell, withExCategory: category)
        let cusCellBackView = UIView()
        cusCellBackView.backgroundColor = SpendAppUtils.getCodeColour("SELECTED")
        cusCell.selectedBackgroundView = cusCellBackView
        cusCellBackView.layer.cornerRadius = 8
        cusCell.layer.cornerRadius = 8
        cusCell.clipsToBounds = true
        return cusCell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fetchResults = fetchedResultsCategory
            let objContext = fetchResults.managedObjectContext
            objContext.delete(fetchResults.object(at: indexPath))
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
    
    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        barButtonEditCategory.isEnabled = true
    }
    
    // Building the Custom Cell
    func buildExCategoryCell(_ cusCell: ExCategoryTableViewCell, withExCategory category: Category) {
        cusCell.textLabelExCategoryName.fadeUpdateTransition(0.5)
        cusCell.textLabelExCategoryName.text = category.name
        
        cusCell.textLabelBudgetAmount.fadeUpdateTransition(0.5)
        cusCell.textLabelBudgetAmount.text =  "\(category.monthlyBudget?.decimalValue ?? 0.0)"
        
        cusCell.textLabelNotes.fadeUpdateTransition(0.5)
        cusCell.textLabelNotes.text = category.notes
        cusCell.labelColour.backgroundColor = SpendAppUtils.getCodeColour(category.colour ?? "DEFUALT")
        
    }
    
    
    // MARK: - Category Fetch Results
    
    func fetchResultsCategory(sortWith sortDescriptor: NSSortDescriptor) -> NSFetchedResultsController<Category>{
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Batch size
        fetchRequest.fetchBatchSize = 20
        
        // Filtering
        let predicateExpense = NSPredicate(format: "profile = %@", SpendAppUtils.profile)
        fetchRequest.predicate = predicateExpense
        
        // Sorting
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Prepare Fetching
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SpendAppUtils.managedAppObjContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        
        // Peform Fectching
        do {
            try aFetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unable to Fetch Data \(nserror), \(nserror.userInfo)")
        }
        
        return aFetchedResultsController
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Updating Data
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
            
            // Handling Multiple segues
            switch segueId {
            
            // Showing Expenses Details
            case "toExpensesDetails":
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    let selectedObj = fetchedResultsCategory.object(at: selectedIndex)
                    
                    // Counting the Click frequecy
                    selectedObj.clickFrequency += 1
                    SpendAppUtils.managedAppObj.saveContext()
                    
                    let expensesVC = (segue.destination as! UINavigationController).topViewController as! ExpensesViewController
                    expensesVC.category = selectedObj
                    expensesViewController = expensesVC
                }
                
            // To Edit popover
            case "toExCategoryEdit":
                if let selectedIndex = tableView.indexPathForSelectedRow {
                    let selectedObj = fetchedResultsCategory.object(at: selectedIndex)
                    let exCategoryAddVC = segue.destination as! AddExCategoryViewController
                    exCategoryAddVC.expenseCategory = selectedObj
                }
            default:
                break
            }
            
        }
    }
}

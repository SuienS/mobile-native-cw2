//
//  ExpensesViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-18.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableViewExpenses: UITableView!
    @IBOutlet weak var barButtonAddExpense: UIBarButtonItem!
    
    // TODO - SETTERS AND GETTERS
    var category: Category? {
        didSet {
            barButtonAddExpense.isEnabled = true
        }
    }
    
    var expensesVals: [Decimal] = [0]
    var totalExpensesVal: Decimal = 1.0
    
    //var _appFetchedResultsController: NSFetchedResultsController<Expense>? = nil
    
    var expenseFetchResController: NSFetchedResultsController<Expense> = NSFetchedResultsController<Expense>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        expenseFetchResController = fetchResultsExpense()
        expensesVals = expenseFetchResController.fetchedObjects?.map {
            $0.amount?.decimalValue ?? 0
        } ?? [0]
        totalExpensesVal = expensesVals.reduce(0, +)
        print(totalExpensesVal)
        
    }
    
    // MARK: - Expenses Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseFetchResController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = expenseFetchResController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cusCell = tableView.dequeueReusableCell(withIdentifier: "cusCellExpense", for: indexPath) as? ExpenseTableViewCell
        else {
            fatalError("Cell Buid Error")
        }
        let expense = expenseFetchResController.object(at: indexPath)
        buildExpenseCell(cusCell, withExpense: expense)
        let cusCellBackView = UIView()
        cusCellBackView.backgroundColor = SpendAppUtils.getCodeColour("SELECTED")
        cusCell.selectedBackgroundView = cusCellBackView
        cusCellBackView.layer.cornerRadius = 8
        cusCell.layer.cornerRadius = 8
        cusCell.clipsToBounds = true
        return cusCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let objContext = expenseFetchResController.managedObjectContext
            objContext.delete(expenseFetchResController.object(at: indexPath))
            
            do {
                try objContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    func buildExpenseCell(_ cusCell: ExpenseTableViewCell, withExpense expense: Expense) {
        cusCell.textFieldExpenseName.text = expense.name ?? "N/A"
        cusCell.textFieldExpenseAmount.text = "\(expense.amount ?? 0)"
        cusCell.textFieldDateNType.text = "\(expense.date ?? Date.distantPast) - \(expense.occurrence ?? "N/A")"
        cusCell.textFieldExpenseNotes.text = expense.notes ?? ""
        if expense.dueReminder{
            cusCell.buttonSetReminder.setTitle("Reminder - ON", for: .normal)
        }
        
        if cusCell.viewBarChart.layer.sublayers != nil {
            cusCell.viewBarChart.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
            cusCell.viewBarChart.layer.sublayers?.forEach({ $0.removeAllAnimations() })
        }
        
        //let dataPieChart = expensesFetch.map { $0.amount ?? 0.0 }
        let expenseBarChartData: [Float] = [
            Float(truncating: (expense.amount ?? 0.0)),
            Float(truncating: totalExpensesVal as NSNumber)
        ]
        
        SpendAppCustomGraphics.buildBarChart(with: expenseBarChartData, on: cusCell.viewBarChart, origin: CGPoint(x: 0,y: cusCell.viewBarChart.frame.height/4), colour: UIColor.systemGreen)
    }
    
    
    // MARK: - Expense Category Fet. Res. Controller
    
    func fetchResultsExpense() -> NSFetchedResultsController<Expense>{
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        // Batch size
        fetchRequest.fetchBatchSize = 20
        
        // Sorting; There's no ordering in CoreData. Hence SortDescriptor is what creates the order
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Predicate to filter assignedCategory
        if let expenseCategory = self.category {
            let predicateExpense = NSPredicate(format: "assignedCategory = %@", expenseCategory)
            fetchRequest.predicate = predicateExpense
        } else {
            print("No Expense Category")
            return NSFetchedResultsController<Expense>()
        }
        
        let aFetchedResultsController = NSFetchedResultsController<Expense>(fetchRequest: fetchRequest, managedObjectContext: SpendAppUtils.managedAppObjContext, sectionNameKeyPath: #keyPath(Expense.category), cacheName: nil)
        aFetchedResultsController.delegate = self
        
        do {
            try aFetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unable to Fetch Data \(nserror), \(nserror.userInfo)")
        }
        
        return aFetchedResultsController
    }
    
    
    //    var expenseFetchResController: NSFetchedResultsController<Expense> {
    //        if _appFetchedResultsController != nil {
    //            return _appFetchedResultsController!
    //        }
    //
    //        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
    //
    //        // Batch size
    //        fetchRequest.fetchBatchSize = 20
    //
    //        // Sorting; There's no ordering in CoreData. Hence SortDescriptor is what creates the order
    //        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
    //
    //        fetchRequest.sortDescriptors = [sortDescriptor]
    //
    //        // Predicate to filter assignedCategory
    //        if let expenseCategory = self.expenseCategory {
    //            let predicateExpense = NSPredicate(format: "assignedCategory = %@", expenseCategory)
    //            fetchRequest.predicate = predicateExpense
    //        } else {
    //            print("No Expense Category")
    //            return NSFetchedResultsController<Expense>()
    //        }
    //
    //        let aFetchedResultsController = NSFetchedResultsController<Expense>(fetchRequest: fetchRequest, managedObjectContext: SpendAppUtils.managedAppObjContext, sectionNameKeyPath: #keyPath(Expense.category), cacheName: nil)
    //        aFetchedResultsController.delegate = self
    //        _appFetchedResultsController = aFetchedResultsController
    //
    //        do {
    //            try _appFetchedResultsController!.performFetch()
    //        } catch {
    //             let nserror = error as NSError
    //             fatalError("Unable to Fetch Data \(nserror), \(nserror.userInfo)")
    //        }
    //        //print(_appFetchedResultsController!.fetchedObjects ?? "No Res")
    //        return _appFetchedResultsController ?? NSFetchedResultsController<Expense>()
    //    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewExpenses.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableViewExpenses.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableViewExpenses.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableViewExpenses.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableViewExpenses.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            buildExpenseCell(tableViewExpenses.cellForRow(at: indexPath!)! as! ExpenseTableViewCell, withExpense: anObject as! Expense)
        case .move:
            buildExpenseCell(tableViewExpenses.cellForRow(at: indexPath!)! as! ExpenseTableViewCell, withExpense: anObject as! Expense)
            tableViewExpenses.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableViewExpenses.endUpdates()
    }
    
    
    // MARK: - Navigation to Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            
            case "toCategoryGraphics":
                let destViewController = segue.destination as! GraphicalDetailsViewController
                if let category = self.category{
                    destViewController.category = category
                    destViewController.expensesFetch = fetchResultsExpense().fetchedObjects
                }
            case "toAddExpense":
                let destViewController = segue.destination as! AddExpenseViewController
                if let exCategory = self.category{
                    destViewController.expenseCategory=exCategory
                } else {
                    print("NO")
                }
            default:
                break
            }
            
        }
    }
    
}

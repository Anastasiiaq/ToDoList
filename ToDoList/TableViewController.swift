//
//  TableViewController.swift
//  ToDoList
//
//  Created by Анастасия on 06.11.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

	var tasks: [Task] = []
	
	@IBAction func saveTask(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "New Task ", message: "Please add a new task", preferredStyle: .alert)
		let saveAction = UIAlertAction(title: "Save", style: .default , handler: { _ in
			let tf = alertController.textFields?.first
			if let newTask = tf?.text {
				self.saveTask(withTitle: newTask)
				self.tableView.reloadData()
			}
		})
		
		alertController.addTextField { _ in }
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
		
		alertController.addAction(saveAction)
		alertController.addAction(cancelAction)
		
		present(alertController, animated: true, completion: nil)
		
	}
	
	private func saveTask (withTitle title: String) {
		let context = getContext()
		
		guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
		
		let taskObject = Task(entity: entity, insertInto: context)
		taskObject.title = title
		
		do {
			try context.save()
			tasks.append(taskObject)				/* add to the end of the list */
//			tasks.insert(taskObject, at: 0)			/* add to the start of the list */
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		
	}
	
	private func getContext() -> NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let context = getContext()
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
		
		do {
			tasks = try context.fetch(fetchRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
//		let context = getContext()
//		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//
//		if let tasks = try? context.fetch(fetchRequest) {
//			for task in tasks {
//				context.delete(task)
//			}
//		}
//
//		do {
//			try context.save()
//		} catch let error as NSError {
//			print(error.localizedDescription)
//		}
		
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		let task = tasks[tasks.count - 1 - indexPath.row]	/* output the list in reverse order */
		cell.textLabel?.text = task.title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

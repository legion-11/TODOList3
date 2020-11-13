//
//  TableViewController.swift
//  TODOList
//
//  Created by legion-11 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //number of items of TableView
    var rows = 0
    
    //index of selected cell for segue
    var cellIndex = IndexPath(row: 0, section: 0)
    var cell: TableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
    //get cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! TableViewCell
        
        return cell
    }
    
    // delete cell with swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            rows -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // click on cell perform segue to edit screen
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cell = tableView.cellForRow(at: indexPath) as? TableViewCell
        cellIndex = indexPath
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    // before swaping screen send data to edit screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControler = segue.destination as? EditViewController {
            viewControler.cell = cell
            viewControler.indexPath = cellIndex
            viewControler.tableViewController = self
        }
    }
    
    // add cell
    @IBAction func addNewCell(_ sender: Any) {
        tableView.beginUpdates()
        rows += 1
        tableView.insertRows(at: [IndexPath(row: rows-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        // open edit screen after added cell
        cell = tableView.cellForRow(at: IndexPath(row: rows-1, section: 0)) as? TableViewCell
        cellIndex = IndexPath(row: rows-1, section: 0)
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    
}

//
//  TableViewController.swift
//  TODOList
//
//  Created by Dmytro Andriichuk $301132978 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //number of items of TableView = titles.count
    // arrays of cells data
    var titles: [String] = []
    var notes: [String] = []
    var dates: [Date] = []
    var hasDate: [Bool] = []
    var isDone: [Bool] = []
    
    //dir where plist will be saved
    let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    
    //get path to plist
    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        // create a blank path
        url = URL(fileURLWithPath: "") as NSURL?
        do {
            url = urls.first?.appendingPathComponent("data.plist") as NSURL?
        }
        
        return url!
    }
    
    // add 1 new element in every cell data array
    func addNewItem() {
        titles.append("")
        notes.append("")
        dates.append(Date())
        hasDate.append(false)
        isDone.append(false)
    }
    
    //del 1 element in every cell data array
    func deleteItem(index: Int){
        titles.remove(at: index)
        notes.remove(at: index)
        dates.remove(at: index)
        hasDate.remove(at: index)
        isDone.remove(at: index)
    }
    
    //index of selected cell for segue
    var cellIndex = IndexPath(row: 0, section: 0)
    var cell: TableViewCell?
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "HH:mm EEEE, d MMMM y"
        
        //load data from plist
        let fileURL = self.dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path!)) {
           print("file exists")
           let loadedDictionary = NSDictionary(contentsOf: fileURL as URL)
           print("load")
           if let dictionary = loadedDictionary {
              print(dictionary)
              titles = dictionary["titles"] as! [String]
              notes = dictionary["notes"] as! [String]
              dates = dictionary["dates"] as! [Date]
              hasDate = dictionary["hasDate"] as! [Bool]
              isDone = dictionary["isDone"] as! [Bool]
           }
        }
    }
    
    //save data to plist
    @objc func saveToPersistentList() {
        let tmpdata = ["titles": titles,
                       "notes": notes,
                       "hasDate": hasDate,
                       "isDone": isDone,
                       "dates": dates] as NSDictionary
        
        let fileURL = self.dataFileURL()
        tmpdata.write(to: fileURL as URL, atomically: true)
        print("saved")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    //get cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! TableViewCell
        
        cell.tableView = self
        cell.indexPath = indexPath
        
        cell.title.text = titles[indexPath.row]
        if (hasDate[indexPath.row] == true) {cell.date.text = formatter.string(from: dates[indexPath.row])}
        else {cell.date.text = ""}
        cell.taskSwitch.isOn = isDone[indexPath.row]
        if cell.taskSwitch.isOn {
            cell.title.textColor = UIColor.gray
            cell.date.textColor = UIColor.gray
        } else if (hasDate[indexPath.row] == true && dates[indexPath.row] < Date()) {
            cell.title.textColor = UIColor.red
            cell.date.textColor = UIColor.red
        } else {
            cell.title.textColor = UIColor.label
            cell.date.textColor = UIColor.label
        }
        return cell
    }
    
    // delete cell with swipe
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            saveToPersistentList()
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
        addNewItem()
        tableView.insertRows(at: [IndexPath(row: titles.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        // open edit screen after adding cell
        cell = tableView.cellForRow(at: IndexPath(row: titles.count-1, section: 0)) as? TableViewCell
        cellIndex = IndexPath(row: titles.count-1, section: 0)
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
}

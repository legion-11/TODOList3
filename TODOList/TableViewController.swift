//
//  TableViewController.swift
//  TODOList
//
//  Created by Dmytro Andriichuk $301132978 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//
//  Assignment #5

import UIKit

class TableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
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
    
    let formatter = DateFormatter()
    
    // gesture to sequence delete swipe gesture in trailing swipes function
    var pressGesture: UILongPressGestureRecognizer? = nil
    
    //instance to navigate push to
    var navigationPoint: EditViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationPoint = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController")as? EditViewController
        pressGesture = UILongPressGestureRecognizer(target: self, action: nil)
        pressGesture!.delegate = self
        tableView.addGestureRecognizer(pressGesture!)
        
        formatter.dateFormat = "HH:mm EEEE, d MMMM y"
        
        //load data from plist
        let fileURL = self.dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path!)) {
            let loadedDictionary = NSDictionary(contentsOf: fileURL as URL)

            if let dictionary = loadedDictionary {
                print("load")
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
        
        cell.title.text = titles[indexPath.row]
        if (hasDate[indexPath.row] == true) {cell.date.text = formatter.string(from: dates[indexPath.row])}
        else {cell.date.text = ""}
        
        if isDone[indexPath.row] {
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
    
    // add cell
    @IBAction func addNewCell(_ sender: Any) {
        tableView.beginUpdates()
        addNewItem()
        tableView.insertRows(at: [IndexPath(row: titles.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        // open edit screen after adding cell
        navigeteLeft(IndexPath(row: titles.count-1, section: 0))
    }
    
    // add trailing swipe gestures
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        //if user longpressed on item for 0.5 seconds than return delete swipe action
        if (pressGesture?.state == UIGestureRecognizer.State.changed) {
            let action = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                self.del(indexPath, true)
                print("delete")
                completionHandler(true)
                
            }
            action.image = UIImage(systemName: "trash")
            action.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions: [action])
        //else return edit swipe action
        } else {
            let action = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                self.complete(indexPath)
                print("complete")
                completionHandler(true)
            }
            action.image = isDone[indexPath.row] ? UIImage(systemName: "xmark") : UIImage(systemName: "checkmark")
            action.backgroundColor = .systemYellow
                
            return UISwipeActionsConfiguration(actions: [action])
        }
    }
    
    // color of completed items
    func complete(_ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        if isDone[indexPath.row] {
            isDone[indexPath.row] = false
            if (hasDate[indexPath.row] == true && (dates[indexPath.row]) < Date() ) {
                // deadline was missed
                cell.title.textColor = UIColor.red
                cell.date.textColor = UIColor.red
            }else{
                // if deadline was not set or deadline in future
                cell.title.textColor = UIColor.label
                cell.date.textColor = UIColor.label
            }
        }else{
            isDone[indexPath.row] = true
            cell.title.textColor = UIColor.gray
            cell.date.textColor = UIColor.gray
        }
        self.saveToPersistentList()
    }
    
    // delete cell and save data
    func del(_ indexPath: IndexPath,_ withAnimation: Bool){
        tableView.beginUpdates()
        deleteItem(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: withAnimation ? .fade : .none)
        tableView.endUpdates()
        saveToPersistentList()
    }
    
    // leading swipe actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
                
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
            self.navigeteLeft(indexPath)
            print("edit")
            completionHandler(true)
        }
        action.image = UIImage(systemName: "pencil")
        action.backgroundColor = .systemBlue
            
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // allowing to recognize press and swipe at the same time
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
     -> Bool {
        return true
    }
    
    // custome navigation animation from left to right
    func navigeteLeft(_ indexPath: IndexPath){
        navigationPoint?.indexPath = indexPath
        navigationPoint?.tableViewController = self
        
        let transition:CATransition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)

        self.navigationController?.pushViewController(navigationPoint!, animated: true)
    }
}

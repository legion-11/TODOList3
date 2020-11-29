//
//  EditViewController.swift
//  TODOList
//
//  Created by Dmytro Andriichuk $301132978 on 12.11.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {}
@IBDesignable class DesignableTextView: UITextView {}
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}


class EditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskNotes: UITextView!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var dateSwitch: UISwitch!
    
    //to format deadline in cell
    let formatter = DateFormatter()
    //link to tableView t perform removing cell
    var tableViewController: TableViewController?
    //cell to get data
    var cell: TableViewCell?
    //path to cell to perform removing cell
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show data from cell
        taskTitle.text = tableViewController?.titles[indexPath.row]
        taskNotes.text = tableViewController?.notes[indexPath.row]
        if (tableViewController?.hasDate[indexPath.row] == true){
            dateSwitch.setOn(true, animated: true)
            taskDate.setDate((tableViewController?.dates[indexPath.row])!, animated: false)
        }
        
        formatter.dateFormat = "HH:mm EEEE, d MMMM y"
        
        //hide back button to create custome one, that can delete cell if data was not provided
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(EditViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // update data from cell if screen was only hidden
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskTitle.text = tableViewController?.titles[indexPath.row]
        taskNotes.text = tableViewController?.notes[indexPath.row]
        if (tableViewController?.hasDate[indexPath.row]) != false{
            dateSwitch.setOn(true, animated: true)
            taskDate.setDate((tableViewController?.dates[indexPath.row])!, animated: false)
        }
    }
    
    //set date switch to ON
    @IBAction func changeDate(_ sender: UIDatePicker) {
        if(!dateSwitch.isOn){dateSwitch.setOn(true, animated: true)}
    }
    
    
    @IBAction func saveDialogTrigger(_ sender: UIButton) {
        let alert = UIAlertController(title: "Save changes?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in self.saveData()}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    //save input to cell and go back to previous screen
    func saveData() {
        cell?.title.text = taskTitle.text
        tableViewController?.titles[indexPath.row] = taskTitle.text ?? ""
        tableViewController?.notes[indexPath.row] = taskNotes.text
        
        //change cell colour depending on deadline time
        cell?.taskSwitch.setOn(false, animated: false)
        tableViewController?.isDone[indexPath.row] = false
        
        tableViewController?.dates[indexPath.row] = taskDate.date
        if(dateSwitch.isOn){
            tableViewController?.hasDate[indexPath.row] = true
            cell?.date.text = formatter.string(from: taskDate.date)
            
            if taskDate.date < Date(){
                cell?.title.textColor = UIColor.red
                cell?.date.textColor = UIColor.red
            }else{
                cell?.title.textColor = UIColor.label
                cell?.date.textColor = UIColor.label
            }
            
        }else{
            tableViewController?.hasDate[indexPath.row] = false
            cell?.date.text = ""

            cell?.title.textColor = UIColor.label
            cell?.date.textColor = UIColor.label
            
        }
        checkIfHasSomething()
    }
    
    @IBAction func cancelDialogTrigger(_ sender: UIButton) {
        let alert = UIAlertController(title: "Cancel changes?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in self.cancel()}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    //press cancel button
    func cancel() {
        checkIfHasSomething()
    }
    //press back button
    @objc func back(sender: UIBarButtonItem) {
        checkIfHasSomething()
    }
    
    @IBAction func deleteDialogTrigger(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete item?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in self.del()}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    //press delete button
     func del() {
        //set cell data to default, so next time you create cell it has default data
        cell?.date.text = ""
        cell?.title.text = ""
        cell?.date.textColor = UIColor.label
        cell?.title.textColor = UIColor.label
        
        //delete cell
        tableViewController?.tableView.beginUpdates()
        tableViewController?.tableView.deleteRows(at: [indexPath], with: .none)
        tableViewController?.deleteItem(index: indexPath.row)
        tableViewController?.tableView.endUpdates()
        tableViewController?.saveToPersistentList()
        _ = navigationController?.popViewController(animated: true)
    }
    
    //hide keyboard when press ouside any editable view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //delete cell if no data was provided
    func checkIfHasSomething(){
        if (tableViewController?.titles[indexPath.row] == "" &&
            tableViewController?.notes[indexPath.row] == "" &&
            tableViewController?.hasDate[indexPath.row] == false){
            
             tableViewController?.tableView.beginUpdates()
             tableViewController?.deleteItem(index: indexPath.row)
             tableViewController?.tableView.deleteRows(at: [indexPath], with: .none)
             tableViewController?.tableView.endUpdates()
        }
        tableViewController?.saveToPersistentList()
        _ = navigationController?.popViewController(animated: true)
    }
    
    // hide keyboard when press return button when firstresponder is edit title field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
}

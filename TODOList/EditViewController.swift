//
//  EditViewController.swift
//  TODOList
//
//  Created by legion-11 on 12.11.2020.
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
        taskTitle.text = cell?.title.text
        taskNotes.text = cell?.notes
        if (cell?.dateOriginal) != nil{
            dateSwitch.setOn(true, animated: true)
            taskDate.setDate(cell?.dateOriginal ?? Date(), animated: false)
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
        taskTitle.text = cell?.title.text
        taskNotes.text = cell?.notes
        if (cell?.dateOriginal) != nil{
            dateSwitch.setOn(true, animated: true)
            taskDate.setDate(cell?.dateOriginal ?? Date(), animated: false)
        }
    }
    
    //set date switch to ON
    @IBAction func changeDate(_ sender: UIDatePicker) {
        if(!dateSwitch.isOn){dateSwitch.setOn(true, animated: true)}
    }
    
    //save input to cell and go back to previous screen
    @IBAction func saveData(_ sender: UIButton) {
        cell?.title.text = taskTitle.text
        cell?.notes = taskNotes.text
        //change cell colour depending on deadline time
        if(dateSwitch.isOn){
            cell?.dateOriginal = taskDate.date
            cell?.date.text = formatter.string(from: taskDate.date)
            if taskDate.date < Date(){
                cell?.title.textColor = UIColor.red
                cell?.date.textColor = UIColor.red
            }else{
                cell?.title.textColor = UIColor.label
                cell?.date.textColor = UIColor.label
            }
        }else{
            cell?.dateOriginal = nil
            cell?.date.text = ""
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    //press cancel button
    @IBAction func cancel(_ sender: UIButton) {
        checkIfHasSomethink()
    }
    //press back button
    @objc func back(sender: UIBarButtonItem) {
        checkIfHasSomethink()
    }
    //press delete button
    @IBAction func del(_ sender: UIButton) {
        //set cell data to default, so next time you create cell it has default data
        cell?.date.text = ""
        cell?.title.text = ""
        cell?.date.textColor = UIColor.label
        cell?.title.textColor = UIColor.label
        cell?.notes = ""
        cell?.dateOriginal = nil
        
        //delete cell
        tableViewController?.tableView.beginUpdates()
        tableViewController?.tableView.deleteRows(at: [indexPath], with: .fade)
        tableViewController?.rows -= 1
        tableViewController?.tableView.endUpdates()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    //hide keyboard when press ouside any editable view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //delete cell if no data was provided
    func checkIfHasSomethink(){
        if (cell?.title.text == "" && cell?.notes == "" && cell?.date.text == ""){
            tableViewController?.rows -= 1
            tableViewController?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    // hide keyboard when press return button when firstresponder is edit title field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

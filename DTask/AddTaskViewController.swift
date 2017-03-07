//
//  AddTaskViewController.swift
//  DTask
//
//  Created by David Bielik on 05/03/17.
//  Copyright © 2017 David Bielik. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    private let unwindIdentifier = "newTaskUnwindSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ViewController else {
            return
        }
        destVC.taskManager!.addTask(text: taskTextField.text!)
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        taskTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        guard let text = taskTextField.text, text.characters.count != 0 else {
            showAlert()
            return
        }
        performSegue(withIdentifier: unwindIdentifier, sender: self)
        
    }
    private func showAlert() {
        let alertController = UIAlertController(title: "Can't create new task.", message: "Task cannot be blank.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}

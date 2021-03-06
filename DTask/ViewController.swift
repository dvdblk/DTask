//
//  ViewController.swift
//  DTask
//
//  Created by David Bielik on 05/03/17.
//  Copyright © 2017 David Bielik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    public var taskManager: TaskManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        taskManager = TaskManager(withDelegate: self)
        loadFromDefaults()
    }
    
    @IBAction func unwindWithAddingTask(segue: UIStoryboardSegue) {
        // unwind segue
    }
    
    private func prepareTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        let cellNib = UINib(nibName: TaskTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TaskTableViewCell.identifier)
    }
}

//
// MARK: - UITableViewDataSource
//
extension ViewController: UITableViewDataSource {
    private func configure(cell: TaskTableViewCell, withTask task: Task) {
        cell.taskLabel.text = task.text
        cell.delegate = self
        cell.task = task
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tm = taskManager else {
            return 0
        }
        return tm.tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier) as! TaskTableViewCell
        let task = taskManager!.tasks[indexPath.row]
        configure(cell: cell, withTask: task)
        return cell
    }
}

extension ViewController: TaskTableViewCellDelegate {
    func didRemoveCell(task: Task) {
        taskManager?.remove(task: task)
    }
}

//
// MARK: - TaskManagerDelegate
//
extension ViewController: TaskManagerDelegate {
    func didAdd(task: Task) {
        tableView.reloadData()
        saveToDefaults()
    }
    
    func didRemove(task: Task, atIndexPath indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        saveToDefaults()
    }
}

//
// MARK: - UserDefaults
//
extension ViewController {
    func loadFromDefaults() {
        guard let loadedTasks = UserDefaults.standard.array(forKey: TaskManager.defaultsKey) as? [TaskDictionary] else {
            return
        }
        taskManager!.loadTasks(fromArray: loadedTasks)
    }
    
    func saveToDefaults() {
        UserDefaults.standard.set(taskManager!.toDefaults(), forKey: TaskManager.defaultsKey)
    }
}

//
//  Task.swift
//  DTask
//
//  Created by David Bielik on 05/03/17.
//  Copyright © 2017 David Bielik. All rights reserved.
//

import Foundation

struct Task {
    var finished: Bool = false
    var text: String = ""
    
    static let finishedString = "finished"
    static let textString = "text"
}

protocol TaskManagerDelegate {
    func didAdd(task: Task)
}

typealias TaskDictionary = [String: Any]

class TaskManager {
    public static let defaultsKey = "tasks"
    public var tasks = [Task]()
    private var delegate: TaskManagerDelegate
    
    init(withDelegate delegate: TaskManagerDelegate) {
        self.delegate = delegate
    }
    
    public func addTask(text: String) {
        let newTask = Task(finished: false, text: text)
        tasks.append(newTask)
        delegate.didAdd(task: newTask)
    }
    
    public func toDefaults() -> [TaskDictionary] {
        var resultDictionary = [TaskDictionary]()
        for task in tasks {
            var taskDictionary = TaskDictionary()
            taskDictionary[Task.textString] = task.text
            taskDictionary[Task.finishedString] = task.finished
            resultDictionary.append(taskDictionary)
        }
        return resultDictionary
    }
    
    public func loadTasks(fromArray tasks: [TaskDictionary]) {
        for task in tasks {
            let taskText = task[Task.textString] as! String
            let taskFinished = task[Task.finishedString] as! Bool
            self.tasks.append(Task(finished: taskFinished, text: taskText))
        }
    }
}

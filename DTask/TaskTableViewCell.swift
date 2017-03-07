//
//  TaskTableViewCell.swift
//  DTask
//
//  Created by David Bielik on 05/03/17.
//  Copyright © 2017 David Bielik. All rights reserved.
//

import UIKit

protocol TaskTableViewCellDelegate {
    func didRemoveCell(task: Task)
}


class TaskTableViewCell: UITableViewCell {

    public static let identifier = "taskTableViewCellIdentifier"
    public static let nibName = "TaskTableViewCell"
    
    public var task: Task?
    public var delegate: TaskTableViewCellDelegate?
    
    private var initialCenter = CGPoint()
    private var generator = UIImpactFeedbackGenerator(style: .light)
    private var deleteOnDragRelease = false {
        didSet {
            if oldValue == false && deleteOnDragRelease == true {
                generator.impactOccurred()
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = UIColor.red
                }, completion: { finished in
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                        self.backgroundColor = UIColor.white
                    }, completion: nil)
                })
            }
        }
    }
    
    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            initialCenter = center
        case .changed:
            let translation = recognizer.translation(in: self)
            if translation.x < 0 {
                center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
                deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            } else {
                center = initialCenter
            }
        case .ended, .cancelled:
            /*let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)*/
            if !deleteOnDragRelease {
                UIView.animate(withDuration: 0.2, animations: {
                    self.center = self.initialCenter
                })
            } else {
                delegate?.didRemoveCell(task: task!)
            }
        default:
            break
        }

    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        var translationSatisfied = false
        var directionSatisfied = false
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                translationSatisfied = true
            }
            let direction = panGestureRecognizer.direction(in: superview!)
            if direction.contains(.Left) {
                directionSatisfied = true
            }
        }
        return translationSatisfied && directionSatisfied
    }
}

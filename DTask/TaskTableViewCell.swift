//
//  TaskTableViewCell.swift
//  DTask
//
//  Created by David Bielik on 05/03/17.
//  Copyright © 2017 David Bielik. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    public static let identifier = "taskTableViewCellIdentifier"
    public static let nibName = "TaskTableViewCell"
    
    private var initialCenter = CGPoint()
    
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
            center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
        case .ended, .cancelled:
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
        default:
            break
        }

    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}

//
//  Task.swift
//  DTask
//
//  Created by David Bielik on 07/03/17.
//  Copyright © 2017 David Bielik. All rights reserved.
//

import Foundation

struct Task {
    var finished: Bool = false
    var text: String = ""
    
    static let finishedString = "finished"
    static let textString = "text"
}

extension Task: Equatable {
    
}

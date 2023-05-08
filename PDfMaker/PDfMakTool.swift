//
//  PDfMakTool.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/28.
//

import Foundation


class PDfMakTool: NSObject {
    
    static let `default` = PDfMakTool()
    
    override init() {
        super.init()
        
    }
    
}

public class Once {
    var already: Bool = false

    public init() {}

    public func run(_ block: () -> Void) {
        guard !already else {
            return
        }
        block()
        already = true
    }
}


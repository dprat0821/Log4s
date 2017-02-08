//
//  Concurrency.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-08.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation


func delay(_ sec: Double, completion: @escaping ()->()) {
    let when = DispatchTime.now() + sec
    DispatchQueue.main.asyncAfter(deadline: when){
        completion()
    }
}

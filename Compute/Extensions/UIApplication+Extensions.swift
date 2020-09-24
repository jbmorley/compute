//
//  UIApplication+Extensions.swift
//  Compute
//
//  Created by Jason Barrie Morley on 24/09/2020.
//

import UIKit

extension UIApplication {

    var documentsUrl: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsDirectory)
    }

}

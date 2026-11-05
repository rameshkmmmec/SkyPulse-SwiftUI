//
//  NavigationRouter.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import SwiftUI

@Observable
final class NavigationRouter {
 
    var path = NavigationPath()
    
    func push(to destination: any Hashable){
        path.append(destination)
    }
    
    func pop(){
        if !path.isEmpty{
            path.removeLast()
        }
    }
    
    func popToRoot(){
        path.removeLast(path.count)
    }
}

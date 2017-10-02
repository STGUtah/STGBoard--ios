//
//  BoardError.swift
//  STGBoard
//
//  Created by Ryan Plitt on 10/2/17.
//  Copyright © 2017 Ryan Plitt. All rights reserved.
//

import Foundation

enum BoardError: Error {
    case locationNotFound
    case boardEmpty
    case cannotConnectToServer
}

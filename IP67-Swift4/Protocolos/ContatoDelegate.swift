//
//  ContatoDelegate.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import Foundation

protocol ContatoDelegate {
    func save(contato: Contato)
    func update(contato: Contato)
}

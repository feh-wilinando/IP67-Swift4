//
//  Contato.swift
//  IP67-Swift4
//
//  Created by Nando on 31/12/17.
//  Copyright © 2017 Nando. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class Contato: NSManagedObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude!.doubleValue, longitude: longitude!.doubleValue)
        }
    }
    
    var title: String? {
        get{
            return nome
        }
    }
    
    var subtitle: String? {
        get {
            return telefone
        }
    }
    
    @NSManaged var foto: UIImage?
    @NSManaged var nome: String?
    @NSManaged var endereco: String?
    @NSManaged var telefone: String?
    @NSManaged var site: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
}

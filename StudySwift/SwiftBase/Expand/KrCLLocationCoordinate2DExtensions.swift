//
//  CLLocationCoordinate2DExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    func isEqual(other: CLLocationCoordinate2D) -> Bool {
        return latitude == other.latitude && longitude == other.longitude
    }

    func distance(to remote: CLLocationCoordinate2D) -> CLLocationDistance {
        let current = CLLocation(latitude: latitude, longitude: longitude)
        let other = CLLocation(latitude: remote.latitude, longitude: remote.longitude)
        return current.distance(from: other)
    }

    func distance(to remote: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationDistance {
        let current = CLLocation(latitude: latitude, longitude: longitude)
        let other = CLLocation(latitude: remote.0, longitude: remote.1)
        return current.distance(from: other)
    }
}

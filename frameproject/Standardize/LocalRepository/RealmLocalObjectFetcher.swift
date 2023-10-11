//
//  RealmLocalObjectFetcher.swift
//  frameproject
//
//  Created by Quang Trinh on 11/10/2023.
//

import Foundation
import RealmSwift
import Realm

class RealmLocalObjectFetcher<Element: Object>: LocalObjectFetcherProtocol {
    func get(id: Any) throws -> Element? {
        do {
            let realm = try Realm()
            return realm.object(ofType: Element.self, forPrimaryKey: id)
        }
        catch {
            throw error
        }
    }
    
    func write(from object: Element) throws {
        do {
            let realm = try Realm()
            realm.safeWrite {
                realm.add(object, update: .all)
            }
        }
        catch {
            throw error
        }
    }
    
    func delete(id: Any) throws {
        do {
            let realm = try Realm()
            guard let obj = realm.object(ofType: Element.self, forPrimaryKey: id) else {
                return
            }
            realm.safeWrite {
                realm.delete(obj)
            }
        }
        catch {
            throw error
        }
    }
    
    func delete(obj: Element) throws {
        do {
            let realm = try Realm()
            realm.safeWrite {
                realm.delete(obj)
            }
        }
        catch {
            throw error
        }
    }
}

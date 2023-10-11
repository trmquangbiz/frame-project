//
//  RealmLocalListFetcher.swift
//  frameproject
//
//  Created by Quang Trinh on 11/10/2023.
//

import Foundation
import RealmSwift
import Realm

class RealmLocalListFetcher<List: RealmCollection>: LocalListFetcherProtocol where List.Element: RealmSwiftObject {
    enum RLMError: Error {
        case notSortDescriptor
    }
    
    func get(predicate: NSPredicate?, sortDescriptors: [Any]) throws -> List {
        do {
            guard let sortDescriptors = sortDescriptors as? [RealmSwift.SortDescriptor] else {
                throw RLMError.notSortDescriptor
            }
            let realm = try Realm()
            if let predicate = predicate {
                return realm.objects(List.Element.self).filter(predicate).sorted(by: sortDescriptors) as! List
            }
            else {
                return realm.objects(List.Element.self).sorted(by: sortDescriptors) as! List
            }
            
        }
        catch {
            throw error
        }
    }
    
    func write(from list: [List.Element]) throws {
        do {
            let realm = try Realm()
            realm.safeWrite {
                realm.add(list, update: .all)
            }
        } catch {
            throw error
        }
    }
    
    func delete(predicate: NSPredicate?) throws {
        do {
            let realm = try Realm()
            var list = realm.objects(List.Element.self)
            if let predicate = predicate {
                list = list.filter(predicate)
            }
            realm.safeWrite {
                realm.delete(list)
            }
        } catch {
            throw error
        }
    }
    
    func delete(_ list: List) throws {
        do {
            let realm = try Realm()
            realm.safeWrite {
                realm.delete(list)
            }
        } catch {
            throw error
        }
    }
}

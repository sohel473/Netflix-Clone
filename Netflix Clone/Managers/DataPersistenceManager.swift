//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/14/22.
//

import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToSaveData
    case failedToFecthData
    case failedToDeleteData
}

class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        //        if let original_title = model.original_title, let original_name = model.original_name {
        //            item.original_title = original_title
        //            item.original_name = original_name
        //        }
        
        guard !checkIfItemExist(id: model.id) else { return }
        
        item.id = Int64(model.id)
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            completion(.success(()))
            NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func checkIfItemExist(id: Int) -> Bool {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" , id)

        do {
            let count = try context.count(for: fetchRequest)
            print(count)
//            if count > 0 {
//                return true
//            } else {
//                return false
//            }
            return count > 0 ? true : false
        }catch {
            print(error)
            return false
        }
    }
    
    func fetchingTitles(completion: @escaping(Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFecthData))
        }
    }
    
    func deleteTitle(model: TitleItem, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}

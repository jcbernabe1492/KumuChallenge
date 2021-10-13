//
//  CoreDataWorker.swift
//  KumuChallenge
//
//  Created by Jc on 10/2/21.
//

import Foundation
import CoreData

final class CoreDataWorker {
    
    static let shared = CoreDataWorker()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KumuChallenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("Store description: \(String(describing: storeDescription.url?.absoluteString))")
            if let error = error as NSError? {
                dump("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    private var movieEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: movieEntityName, in: context)
    }
    
    private let movieEntityName = "MovieEntity"
    
    // MARK: - Manage Context
    
    func saveContext(completion: ResultClosure? = nil) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion?(.success(nil))
            } catch {
                let nserror = error as NSError
                dump("Unresolved error \(nserror), \(nserror.userInfo)")
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - CRUD Functions
    
    func saveMovie(_ movie: Movie, completion: ResultClosure? = nil) {
        guard let _movieEntity = movieEntity,
              let trackId = movie.trackId else {
            return
        }
        
        do {
            let fetchResult = try context.fetch(createTrackIdFetchRequest(trackId))
            if fetchResult.count == 1,
               let toUpdate = fetchResult.first as? NSManagedObject {
                toUpdate.setValue(movie.trackId, forKey: Movie.CodingKeys.trackId.rawValue)
                setMovieValues(movie, toManagedObj: toUpdate, isUpdate: true)
            } else {
                let newMovie = NSManagedObject(entity: _movieEntity, insertInto: context)
                newMovie.setValue(trackId, forKey: Movie.CodingKeys.trackId.rawValue)
                setMovieValues(movie, toManagedObj: newMovie, isUpdate: false)
            }
            saveContext(completion: completion)
        } catch let error {
            print("Save movie error: \(error)")
        }
    }
    
    func fetchMovies() -> [Movie] {
        do {
            let fetchResults = try context.fetch(createMovieFetchRequest())
            if fetchResults.count > 0, let results = fetchResults as? [NSManagedObject] {
                var movies: [Movie] = []
                
                results.forEach { object in
                    let movie = Movie()
                    movie.trackId = object.value(forKey: Movie.CodingKeys.trackId.rawValue) as? Int
                    movie.trackName = object.value(forKey: Movie.CodingKeys.trackName.rawValue) as? String
                    
                    movie.artistName = object.value(forKey: Movie.CodingKeys.artistName.rawValue) as? String ?? ""
                    
                    movie.artworkUrl100 = object.value(forKey: Movie.CodingKeys.artworkUrl100.rawValue) as? String
                    
                    movie.trackPrice = object.value(forKey: Movie.CodingKeys.trackPrice.rawValue) as? Double
                    movie.trackRentalPrice = object.value(forKey: Movie.CodingKeys.trackRentalPrice.rawValue) as? Double
                    movie.trackHdPrice = object.value(forKey: Movie.CodingKeys.trackHdPrice.rawValue) as? Double
                    movie.trackHdRentalPrice = object.value(forKey: Movie.CodingKeys.trackHdRentalPrice.rawValue) as? Double
                    
                    movie.collectionId = object.value(forKey: Movie.CodingKeys.collectionId.rawValue) as? Int
                    movie.collectionName = object.value(forKey: Movie.CodingKeys.collectionName.rawValue) as? String
                    movie.collectionPrice = object.value(forKey: Movie.CodingKeys.collectionPrice.rawValue) as? Double
                    movie.collectionHdPrice = object.value(forKey: Movie.CodingKeys.collectionHdPrice.rawValue) as? Double
                    
                    movie.currency = object.value(forKey: Movie.CodingKeys.currency.rawValue) as? String ?? ""
                    movie.primaryGenreName = object.value(forKey: Movie.CodingKeys.primaryGenreName.rawValue) as? String ?? ""
                    movie.trackTimeMillis = object.value(forKey: Movie.CodingKeys.trackTimeMillis.rawValue) as? Int
                    movie.longDescription = object.value(forKey: Movie.CodingKeys.longDescription.rawValue) as? String
                    
                    movie.isFavorite = object.value(forKey: Movie.CodingKeys.isFavorite.rawValue) as? Bool ?? false
                    movies.append(movie)
                }
                
                return movies
            } else {
                return []
            }
        } catch let error {
            print("Fetch movies error: \(error)")
        }
        return []
    }
    
    func updateFavoriteMovie(trackId: Int, isFavorite: Bool) {
        do {
            let fetchResult = try context.fetch(createTrackIdFetchRequest(trackId))
            if fetchResult.count == 1,
               let toUpdate = fetchResult.first as? NSManagedObject {
                toUpdate.setValue(isFavorite, forKey: Movie.CodingKeys.isFavorite.rawValue)
                saveContext()
            }
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Helper Functions
    
    private func setMovieValues(_ movie: Movie, toManagedObj: NSManagedObject, isUpdate: Bool) {
        toManagedObj.setValue(movie.trackName, forKey: Movie.CodingKeys.trackName.rawValue)
        
        toManagedObj.setValue(movie.artistName, forKey: Movie.CodingKeys.artistName.rawValue)
        
        toManagedObj.setValue(movie.artworkUrl100, forKey: Movie.CodingKeys.artworkUrl100.rawValue)
        
        toManagedObj.setValue(movie.trackPrice, forKey: Movie.CodingKeys.trackPrice.rawValue)
        toManagedObj.setValue(movie.trackRentalPrice, forKey: Movie.CodingKeys.trackRentalPrice.rawValue)
        toManagedObj.setValue(movie.trackHdPrice, forKey: Movie.CodingKeys.trackHdPrice.rawValue)
        toManagedObj.setValue(movie.trackHdRentalPrice, forKey: Movie.CodingKeys.trackHdRentalPrice.rawValue)
        
        toManagedObj.setValue(movie.collectionId, forKey: Movie.CodingKeys.collectionId.rawValue)
        toManagedObj.setValue(movie.collectionName, forKey: Movie.CodingKeys.collectionName.rawValue)
        toManagedObj.setValue(movie.collectionPrice, forKey: Movie.CodingKeys.collectionPrice.rawValue)
        toManagedObj.setValue(movie.collectionHdPrice, forKey: Movie.CodingKeys.collectionHdPrice.rawValue)
        
        toManagedObj.setValue(movie.currency, forKey: Movie.CodingKeys.currency.rawValue)
        toManagedObj.setValue(movie.primaryGenreName, forKey: Movie.CodingKeys.primaryGenreName.rawValue)
        toManagedObj.setValue(movie.trackTimeMillis, forKey: Movie.CodingKeys.trackTimeMillis.rawValue)
        toManagedObj.setValue(movie.longDescription, forKey: Movie.CodingKeys.longDescription.rawValue)
        
        if !isUpdate {
            toManagedObj.setValue(movie.isFavorite, forKey: Movie.CodingKeys.isFavorite.rawValue)
        }
    }
    
    private func createMovieFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntityName)
        return fetchRequest
    }
    
    private func createTrackIdFetchRequest(_ trackId: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntityName)
        fetchRequest.predicate = NSPredicate(format: "\(Movie.CodingKeys.trackId.rawValue) == %i", trackId)
        return fetchRequest
    }
}

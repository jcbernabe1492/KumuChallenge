//
//  CoreDataWorker.swift
//  KumuChallenge
//
//  Created by Jc on 10/2/21.
//

import Foundation
import CoreData

/// Worker class that will handle all core data related processes.
final class CoreDataWorker {
    
    /// Singleton instance.
    static let shared = CoreDataWorker()
    
    /// Reference to persistent container.
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
    
    /// Reference to *NSManagedObjectContext.*
    private lazy var context = persistentContainer.viewContext
    
    /// Reference to movie entity.
    private var movieEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: movieEntityName, in: context)
    }
    
    /// Name constant of move entity.
    private let movieEntityName = "MovieEntity"
    
    // MARK: - Manage Context
    
    /// Save managed object context to apply changes within persistent store.
    /// - Parameter completion: Result closure that tells if saving succeeds or not.
    func saveContext(completion: ResultClosure? = nil) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion?(.success(nil))
            } catch {
                let nserror = error as NSError
                dump("Unresolved error \(nserror), \(nserror.userInfo)")
                completion?(.failure(.contextError(error: error)))
            }
        }
    }
    
    // MARK: - CRUD Functions
    
    /// Save a movie to persistent store.
    /// - Parameters:
    ///   - movie: Movie model that contains details to be saved.
    ///   - completion: Result closure that tells if saving succeeds or not.
    func saveMovie(_ movie: Movie, completion: ResultClosure? = nil) {
        guard let _movieEntity = movieEntity,
              let trackId = movie.trackId else {
            completion?(.failure(.saveError(error: nil)))
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
    
    /// Fetch all movies saved within the persistent store.
    /// - Parameter isFavorites: If fetching should get favorite movies list or all movies list.
    /// - Returns: Array of movies, with each item containing details of each entry in the persistent store.
    func fetchMovies(isFavorites: Bool = false) -> [Movie] {
        do {
            let fetchResults = try context.fetch(createMovieFetchRequest(isFavorites: isFavorites))
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
    
    /// Update a movie to set if it's the users favorite or not.
    /// - Parameters:
    ///   - trackId: Track id of the movie to be updated.
    ///   - isFavorite: If movie is favorite or not.
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
    
    /// Set movie values to an *NSManagedObject*.
    /// - Parameters:
    ///   - movie: Movie model that contains details to be saved.
    ///   - toManagedObj: *NSManagedObject* instance where movie details will be set.
    ///   - isUpdate: If setting of values is requested as part of inserting new entry or just updating an existing one.
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
    
    /// Create fetch request for retreiving movie lists.
    /// - Parameter isFavorites: If data to be requested is for fetching favorite movies or not.
    /// - Returns: *NSFetchRequest* instance to be used when trying to get data from the persistent store.
    private func createMovieFetchRequest(isFavorites: Bool) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntityName)
        if isFavorites {
            fetchRequest.predicate = NSPredicate(format: "isFavorite == 1")
        }
        return fetchRequest
    }
    
    /// Create fetch request for getting an entry with a specific track id.
    /// - Parameter trackId: Track id of entry to be fetched.
    /// - Returns: *NSFetchRequest* instance to be used when trying to get data from the persistent store.
    private func createTrackIdFetchRequest(_ trackId: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntityName)
        fetchRequest.predicate = NSPredicate(format: "\(Movie.CodingKeys.trackId.rawValue) == %i", trackId)
        return fetchRequest
    }
}

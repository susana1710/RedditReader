//
//  CoreDataPostDataSource.swift
//  RedditReader
//
//  Created by Susana Charara on 9/11/22.
//

import Foundation
import CoreData

class CoreDataPostDataSource: PostDataSourceProtocol {
  private let container: NSPersistentContainer
  
  init(container: NSPersistentContainer) {
    self.container = container
  }
  
  func getPosts() async -> Result<[Post], Error> {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PostEntity")
    do {
      let entities = try container.viewContext.fetch(fetchRequest) as! [PostEntity]
      let posts = entities.map {mapToPost(postEntity: $0)}
      return .success(posts)
    } catch let error {
      print("Error fetching posts \(error.localizedDescription)")
      return .failure(error)
    }
  }
  
  func getOne(_ id: String) async -> Result<Post?, Error> {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PostEntity")
    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
    do {
      let entities = try container.viewContext.fetch(fetchRequest) as! [PostEntity]
      assert(entities.count<2, "Several posts with same id found")
      if entities.count > 0 {
        let posts = entities.map { mapToPost(postEntity: $0) }
        return .success(posts[0])
      }
      return .success(nil)
    } catch let error {
      print("Error fetching posts \(error.localizedDescription)")
      return .failure(error)
    }
  }
  
  func createOne(_ post: Post) async -> Result<Bool, Error> {
    do {
      let backgroundContext = container.newBackgroundContext()
      let postEntity = mapToPostEntity(post: post, context: backgroundContext)
      try await saveBackgrgoundContext(backgroundContext)
      return .success(true)
    } catch let error {
      print("Error saving post \(error.localizedDescription)")
      return .failure(error)
    }
    
  }
  
  private func saveBackgrgoundContext(_ backgroundContext: NSManagedObjectContext) async throws {
    try await backgroundContext.perform { [weak self] in
      guard let self = self else { return }
      try backgroundContext.save()
      DispatchQueue.main.async {
        self.container.viewContext.perform {
          try? self.container.viewContext.save()
        }
      }
    }
  }
  
  func createMany(_ posts: [Post]) async -> Result<Bool, Error> {
    let backgroundContext = container.newBackgroundContext()
    for post in posts {
      // Create post entities
      _ = mapToPostEntity(post: post, context: backgroundContext)
    }
    do {
      try await saveBackgrgoundContext(backgroundContext)
      return .success(true)
    } catch let error {
        print("Error saving multiple posts \(error.localizedDescription)")
        return .failure(error)
    }
  }
  
  func update(id: String, data: Post) async -> Result<Bool, Error> {
    // TODO: IMPLEMENT
    return .success(false)
  }
  
  func delete(_ id: String) async -> Result<Bool, Error> {
    // TODO: IMPLEMENT
    return .success(false)
  }
  
  private func mapToPost(postEntity: PostEntity) -> Post {
    let post = Post()
    post.id = postEntity.id
    post.order = Int(postEntity.order)
    post.author = postEntity.author
    post.creationDate = postEntity.creationDate as NSDate?
    post.subreddit = postEntity.subreddit
    post.thumbnailURL = postEntity.thumbnailURL
    post.mediaURL = postEntity.mediaURL
    post.title = postEntity.title
    post.commentCount = Int(postEntity.commentCount)
    
    return post
  }
  
  private func mapToPostEntity(post: Post, context: NSManagedObjectContext) -> PostEntity {
    let postEntity = PostEntity(context: context)
    postEntity.id = post.id
    postEntity.order = Int32(post.order ?? 0)
    postEntity.author = post.author
    postEntity.creationDate = post.creationDate as? Date
    postEntity.subreddit = post.subreddit
    postEntity.thumbnailURL = post.thumbnailURL
    postEntity.mediaURL = post.mediaURL
    postEntity.title = post.title
    postEntity.commentCount = Int32(post.commentCount ?? 0)
    
    return postEntity
  }
  
}

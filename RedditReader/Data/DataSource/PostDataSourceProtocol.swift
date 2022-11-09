//
//  PostDataSourceProtocol.swift
//  RedditReader
//
//  Created by Susana Charara on 9/11/22.
//

import Foundation
protocol PostDataSourceProtocol {
  func getPosts() async -> Result<[Post], Error>
  func getOne(_ id: String) async -> Result<Post?, Error>
  func createOne(_ post: Post) async -> Result<Bool, Error>
  func createMany(_ posts: [Post]) async -> Result<Bool, Error>
  func update(id: String, data: Post) async -> Result<Bool, Error>
  func delete(_ id: String) async  -> Result<Bool, Error>
}

extension PostDataSourceProtocol {
  
  // Provide default implementations to make these methods optionals
  
  func getOne(_ id: String) async -> Result<Post?, Error> {
    return .success(Post())
  }
  
  func createOne(_ post: Post) async -> Result<Bool, Error> {
    return .success(true)
  }
  
  func createMany(_ posts: [Post]) async -> Result<Bool, Error> {
    return .success(true)
  }
  
  func update(id: String, data: Post) async   -> Result<Bool, Error> {
    return .success(true)
  }
  
  func delete(_ id: String) async  -> Result<Bool, Error> {
    return .success(true)
  }
}

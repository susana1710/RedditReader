//
//  PostsRepository.swift
//  RedditReader
//
//  Created by Susana Charara on 9/11/22.
//

import Foundation

class PostsRepository: PostsRepositoryProtocol {
  
  // FIXME
  var dataSource: PostDataSourceProtocol
  
  init(dataSource: PostDataSourceProtocol) {
    self.dataSource = dataSource
  }
  func fetchPostsList() async -> Result<[Post], Error> {
    await dataSource.getPosts()
  }
  
}

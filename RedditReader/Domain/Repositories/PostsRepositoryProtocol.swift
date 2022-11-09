//
//  PostsRepository.swift
//  RedditReader
//
//  Created by Susana Charara on 8/11/22.
//

import Foundation

protocol PostsRepositoryProtocol {
  func fetchPostsList() async -> Result<[Post], Error>
}

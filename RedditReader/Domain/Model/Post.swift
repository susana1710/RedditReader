//
//  Post.swift
//  RedditReader
//
//  Created by Susana Charara on 7/11/22.
//

import Foundation

class Post: NSObject {
  
  var id: String?
  var order: Int?
  var title: String?
  var author: String?
  var creationDate: NSDate?
  var thumbnailURL: String?
  var mediaURL: String?
  var commentCount: Int?
  var subreddit: String?
  
}

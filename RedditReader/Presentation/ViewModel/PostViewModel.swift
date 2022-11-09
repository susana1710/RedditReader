//
//  PostViewModel.swift
//  RedditReader
//
//  Created by Susana Charara on 8/11/22.
//

import Foundation

class PostViewModel {
  
  var title: Box<String?> = Box("")
  var author: Box<String?> = Box("")
  var creationDate: Box<String?> = Box("")
  var mediaURL: Box<URL?> = Box(nil)
  var thumbnailURL: Box<URL?> = Box(nil)
  var commentCount: Box<Int?> = Box(nil)
  var subreddit: Box<String?> = Box("")
  
  init() {
    title = Box("")
    author = Box("")
    creationDate  = Box("")
    mediaURL = Box(nil)
    thumbnailURL = Box(nil)
    commentCount = Box(nil)
    subreddit = Box("")
  }
  
  init(from post: Post) {
    self.title = Box(post.title)
    self.author = Box(post.author)
    self.subreddit = Box(post.subreddit)
    if let creationDate = post.creationDate {
      self.creationDate = Box(dateFormatter.string(from: creationDate as Date))
    }
    //FIXME
    if post.thumbnailURL != nil,
       let thumbnailURL = URL.init(string: post.thumbnailURL!) {
      self.thumbnailURL = Box(thumbnailURL)
    }
    if post.mediaURL != nil,
       let mediaURL = URL.init(string: post.mediaURL!) {
      self.mediaURL = Box(mediaURL)
    }
    self.commentCount = Box(post.commentCount)
  }
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter
  }()
}

//
//  Quote.swift
//  Thinking
//
//  Created by kenjimaeda on 02/08/22.
//

import Foundation

struct Quote: Codable {
	var quote: String
	var author: String
	var image: String
	
	var quoteFormated: String {
		return  "❝\(quote)❞"
	}
	
	var authorFormated: String {
		return  "- \(author) -"
	}
	
}

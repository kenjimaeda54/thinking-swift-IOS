//
//  QuoteManager.swift
//  Thinking
//
//  Created by kenjimaeda on 02/08/22.
//

import Foundation

protocol QuoteProtocol {
	func getQuote(_ quote: Quote)
}

struct QuoteManager {
	
	var quote: [Quote]?
	var quoteDelegate: QuoteProtocol?
	

	mutating func urlPrepare() {
		//bundle e para pegar arquivos locais
		//fica localizados na maior hirarquia do app,mesmo local que esta as configuracoes do app
		//na aba Build Phases
		if let fileUrl = Bundle.main.url(forResource: "quotes", withExtension: ".json"){
			do {
				let jsonData = try Data(contentsOf: fileUrl)
				if let quote =  parserJson(jsonData) {
					quoteDelegate?.getQuote(quote)
					
				}
			}catch {
				print(error)
			}
		}
	}
		
	mutating func parserJson(_ data: Data) -> Quote? {
			do {
				let decoder = JSONDecoder()
				quote = try decoder.decode([Quote].self, from: data)
				if let quoteElement = quote?.randomElement() {
					 return quoteElement
				}
			}catch {
				print(error)
				return nil
			}
		  return nil
		}
}

//
//  ViewController.swift
//  Thinking
//
//  Created by kenjimaeda on 02/08/22.
//

import UIKit

class QuotesViewController: UIViewController {
	
	@IBOutlet weak var imgBg: UIImageView!
	@IBOutlet weak var imgPhoto: UIImageView!
	@IBOutlet weak var labQuotes: UILabel!
	@IBOutlet weak var labAuthor: UILabel!
	@IBOutlet weak var nsTopConstraint: NSLayoutConstraint!
	
	var quote = QuoteManager()
	var configuration = Configuration()
	var timer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//self precisa estar sempre na frente das funcoes
		quote.quoteDelegate = self
		quote.urlPrepare()

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//adicionado observador
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
			self.quote.urlPrepare()
		}
		quote.urlPrepare()
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.quote.urlPrepare()
	}
	
	func  formatView(_ quote: Quote) {
		//invalidar para zerar qualquer efeito colateral
		timer?.invalidate()
		
		view.backgroundColor = configuration.colorScheme == 0 ? .white : UIColor(red: 156.0/255.0,green: 68.0/255.0, blue: 15.0/255.0, alpha: 1.0)
		labQuotes.textColor = configuration.colorScheme == 0 ? .black : .white
		labAuthor.textColor = configuration.colorScheme == 0 ? UIColor(red: 156.0/255.0, green: 68.0/255.0, blue: 15.0/255.0, alpha: 1.0) : .yellow

	
		if configuration.repeatCycle {
			timer = Timer.scheduledTimer(withTimeInterval: configuration.timeInterval, repeats: true, block: { (timer) in
				self.quote.urlPrepare()
			})
		}
		
		showQuote(quote)
	}
	
	func showQuote(_ quote:Quote) {
		imgBg.image = UIImage(named: quote.image)
		imgPhoto.image = UIImage(named: quote.image)
		labAuthor.text = quote.author
		labQuotes.text = quote.quote
		
		labQuotes.alpha = 0.0
		labAuthor.alpha = 0.0
		imgBg.alpha = 0.0
		imgPhoto.alpha = 0.0
		//vai comecar maior a constraint
		nsTopConstraint.constant = 50
		//preciso pedir para todos alinharem
		view.layoutIfNeeded()
		
		UIView.animate(withDuration: 2.5) {
			self.labQuotes.alpha = 1.0
			self.labAuthor.alpha = 1.0
			self.imgBg.alpha = 0.25
			self.imgPhoto.alpha = 1.0
			self.nsTopConstraint.constant = 15
			self.view.layoutIfNeeded()
		}
		
	}
	
}


//MARK: - QuoteProtocol

extension QuotesViewController:QuoteProtocol {
	func getQuote(_ quote: Quote) {
		formatView(quote)
	}
}


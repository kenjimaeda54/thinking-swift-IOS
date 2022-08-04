# Thinking
Aplicativo de pensamentos. Possível configurar tempo de animação, ciclos infintos e o tempo do ciclo

## Feature
- Usei o ciclo de vida do IOS 
- Utilizei objeto NotificationCenter, para monitorar mudanças no app ao ser aberto ou fechado
- Para ser aplicado corretametne usei o arquivo SceneDelegate
- Método sceneDidBecomeActive e ativado sempre que uma scene esta ativada

```swift

//SeceneDelegate
func sceneDidBecomeActive(_ scene: UIScene) {
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: nil)
	}
  
  
//QuotesViewController
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
			self.quote.urlPrepare()
		}
		quote.urlPrepare()
	}
	
```

##
- Aprendi o uso de armazenamento local
- Objeto UserDefaults e responsável pelo armazenamento local
- Para recuperar o valor usamos os metodos .doble, .integer, .boll
- Para setar usamos o método set
- Pradrão caso não tenha o valor da chave o método integer retorna 0, método boll False e o double retorna 0
- Apliquei uso do Enum, para consultar os [conceitos swift](https://github.com/kenjimaeda54/concepts-swift)


```swift

enum UserDefaultsKeys: String {
	case timeInterval = "timeInterval"
	case repeatCycle = "repeatCycle"
	case colorScheme = "colorScheme"
}

struct Configuration  {
	
	let userDefaults = UserDefaults.standard
	
	init() {
		if userDefaults.double(forKey: UserDefaultsKeys.timeInterval.rawValue) < 5 {
			userDefaults.set(8.0, forKey: UserDefaultsKeys.timeInterval.rawValue)
		}
	}
	
	var timeInterval: Double {
		get {
			return  userDefaults.double(forKey: UserDefaultsKeys.timeInterval.rawValue )
		}set {
			userDefaults.set(newValue, forKey: UserDefaultsKeys.timeInterval.rawValue)
		}
	}
	
	var repeatCycle: Bool {
		get {
			return userDefaults.bool(forKey: UserDefaultsKeys.repeatCycle.rawValue)
		}set {
			userDefaults.set(newValue, forKey: UserDefaultsKeys.repeatCycle.rawValue)
		}
	}
	
	var colorScheme: Int  {
		get {
			return userDefaults.integer(forKey: UserDefaultsKeys.colorScheme.rawValue)
		}set {
			userDefaults.set(newValue, forKey: UserDefaultsKeys.colorScheme.rawValue)
		}
	}
	
}

```

##
- Caso implemente uma extension sempre que  deseja  atualizar os dados precisa chamar o método que executa o protocolo
- No meu caso e o método urlPrepare()
- Usei novamente estrategia de bundle, para executar um arquivo que está em meu aplicativo
- Utilizo o objeto Bundle.main.ulr para instanciar o arquivo
- Método Data para transformar arquivo em algo lido pelo Swift
- Por fim, caso o Data seja Json, utilizo o JSONDecoder()
- Estas etapas são bem parecidas quando realiza uma requisição no [browser](https://github.com/kenjimaeda54/clima-Swift-IOS)
- Quando lida com tempo e sempre ideal antes invalidar, assim evitamos efeitos colaterais 

```swift

// QuotesViewController


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



//QuoteManager

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




```


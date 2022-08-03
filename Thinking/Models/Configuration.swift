//
//  Configuration.swift
//  Thinking
//
//  Created by kenjimaeda on 02/08/22.
//

import Foundation

enum UserDefaultsKeys: String {
	case timeInterval = "timeInterval"
	case repeatCycle = "repeatCycle"
	case colorScheme = "colorScheme"
}

struct Configuration  {
	
	let userDefaults = UserDefaults.standard
	
	init() {
		//nosso intervalo o minimo e 5,caso nao tenha nada salvo no celular
		//ira retornar 0
		//nao preciso verificar o inteiro porque por padrao salva 0
		//nao preciso verificar o boleano porque por padrao salva false
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

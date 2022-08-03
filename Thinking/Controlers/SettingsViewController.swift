//
//  SettingsViewController.swift
//  Thinking
//
//  Created by kenjimaeda on 02/08/22.
//

import UIKit

class SettingsViewController: UIViewController {
	
	
	@IBOutlet weak var swChangeAutomatic: UISwitch!
	@IBOutlet weak var labTitleSlider: UILabel!
	@IBOutlet weak var segmeColor: UISegmentedControl!
	@IBOutlet weak var sliderInterval: UISlider!
	
	var configuration = Configuration()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Refresh"), object: nil, queue: nil) { (notification) in
			self.formatView()
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		formatView()
		
	}
	
	func formatView() {
		swChangeAutomatic.setOn(configuration.repeatCycle, animated: false)
		segmeColor.selectedSegmentIndex = configuration.colorScheme
		sliderInterval.setValue(Float(configuration.timeInterval), animated: false)
		formatChangeLabel(configuration.timeInterval)
	}
	
	func	formatChangeLabel(_ label: Double) {
		labTitleSlider.text = "Change after \(String(format:"%.0f",label))"
	}
	
	@IBAction func changeAutomatic(_ sender: UISwitch) {
		configuration.repeatCycle = sender.isOn
	}
	
	@IBAction func sliderSeconds(_ sender: UISlider) {
		let value = Double(sender.value)
		configuration.timeInterval = value
		formatChangeLabel(value)
	}
	
	@IBAction func changeSegment(_ sender: UISegmentedControl) {
		configuration.colorScheme = sender.selectedSegmentIndex
	}
}

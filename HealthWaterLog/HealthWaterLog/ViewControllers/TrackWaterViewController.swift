//
//  FirstViewController.swift
//  HealthWaterLog
//
//

import UIKit

class TrackWaterViewController: UIViewController {
    
    private let addWaterButton = UIButton(type: .system)
    private let updateGoalButton = UIButton(type: .system)
    
    private var viewModel: TrackWaterViewModel!
    
    init(viewModel: TrackWaterViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
        setUpButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func setUpButtons() {
        addWaterButton.setTitle(viewModel.addWaterLabel, for: .normal)
        addWaterButton.addTarget(self, action: #selector(addWaterButtonPressed), for: .touchUpInside)
        updateGoalButton.setTitle(viewModel.updateDailyGoalLabel, for: .normal)
        updateGoalButton.addTarget(self, action: #selector(goalButtonPressed), for: .touchUpInside)
        
        setUpColor()
        setUpConstraints()
    }
    
    @objc private func goalButtonPressed() {
        showPromptForGoalSetting { [weak self] goal in
            self?.viewModel.addGoal(goal)
        }
    }
    
    @objc private func addWaterButtonPressed() {
        viewModel.addWaterIntake()
    }
    
    private func setUpColor() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        let container = UIView()
        addWaterButton.translatesAutoresizingMaskIntoConstraints = false
        updateGoalButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(addWaterButton)
        container.addSubview(updateGoalButton)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(container)
        
        // Buttons constraints
        let addWaterButtonConstraints = [addWaterButton.topAnchor.constraint(equalTo: container.topAnchor),
                                         addWaterButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                         addWaterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),]
        
        NSLayoutConstraint.activate(addWaterButtonConstraints)
        
        let updateGoalButtonConstraints = [updateGoalButton.topAnchor.constraint(equalTo: addWaterButton.bottomAnchor, constant: 10),
                                           updateGoalButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                                           updateGoalButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                                           updateGoalButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)]
        
        NSLayoutConstraint.activate(updateGoalButtonConstraints)
        
        // ContainerView constraints
        
        let containerConstraints = [container.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                    container.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                    container.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
                                    container.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
                                    container.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
                                    container.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(containerConstraints)
        
    }
    
    private func showPromptForGoalSetting(submitAction:@escaping (Int)->()) {
        let alertController = UIAlertController.alertForGoalSetting(submitAction: submitAction)
        present(alertController, animated: true)
    }
}

extension UIAlertController {
    fileprivate static func alertForGoalSetting(submitAction:@escaping (Int)->()) -> UIAlertController {
        let alertController = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Put some number"
            textField.keyboardType = .numberPad
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            let answer = alertController.textFields![0]
            let goal = Int(answer.text ?? "") ?? 0
            
            submitAction(goal)
        }
        
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
}


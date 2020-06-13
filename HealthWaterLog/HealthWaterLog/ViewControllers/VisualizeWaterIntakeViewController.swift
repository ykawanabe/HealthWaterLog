//
//  SecondViewController.swift
//  HealthWaterLog
//
//

import UIKit

class VisualizeWaterIntakeViewController: UIViewController {

    private let label = UILabel()
    
    private var viewModel: VisualizeWaterIntakeViewModel!
    
    init(viewModel: VisualizeWaterIntakeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.currentState.bind({ [weak self] text in
            DispatchQueue.main.async {
                self?.label.text = text
            }
        })
    }

    private func setUpLayout() {
        label.textAlignment = .center
        
        setUpColor()
        setUpConstraints()
    }
    
    private func setUpColor() {
        label.textColor = UIColor.label
        self.view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


//
//  SecondViewController.swift
//  HealthWaterLog
//
//

import UIKit

class VisualizeWaterIntakeViewController: UIViewController {

    private let label = UILabel()
    private let stackView = UIStackView()
    
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
        
        setUpStackView()
        setUpColor()
        setUpConstraints()
    }

    private func setUpStackView() {
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        
        let label = UILabel()
        label.text = "History: "
        stackView.addArrangedSubview(label)
        
        for text in viewModel.historyStrings {
            let label = UILabel()
            label.text = text
            stackView.addArrangedSubview(label)
        }
    }
    
    private func setUpColor() {
        label.textColor = UIColor.label
        self.view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.0),
        ])
    }
}


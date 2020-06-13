//
//  SecondViewController.swift
//  HealthWaterLog
//
//

import UIKit

class VisualizeWaterIntakeViewController: UIViewController {

    private let mainContainer = UIStackView()
    private let label = UILabel()
    private let historyStackView = UIStackView()
    
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
        mainContainer.axis = .vertical
        mainContainer.spacing = 16.0
        
        label.textAlignment = .center
        
        setUpHistoryStackView()
        setUpColor()
        setUpConstraints()
    }

    private func setUpHistoryStackView() {
        historyStackView.axis = .vertical
        
        let label = UILabel()
        label.text = "History: "
        historyStackView.addArrangedSubview(label)
        
        for text in viewModel.historyStrings {
            let label = UILabel()
            label.text = text
            historyStackView.addArrangedSubview(label)
        }
    }
    
    private func setUpColor() {
        label.textColor = UIColor.label
        self.view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainContainer)

        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
        ])
        
        mainContainer.addArrangedSubview(label)
        mainContainer.addArrangedSubview(historyStackView)
    }
}


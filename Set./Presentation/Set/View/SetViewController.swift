//
//  ViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit
import Combine
import CoreData

final class SetViewController: UIViewController, CollectionViewCellDelegate {
    
    private var subscriber = Set<AnyCancellable>()
    
    private var constraints: [NSLayoutConstraint] = []
    private var collectionView : UICollectionView?
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var viewModel = SetViewModel(coreDataStack: CoreDataStack(modelName: "Data"))
    
    private var scoreController: UIButton {
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(scale: .large)
        let boldList = UIImage(systemName: "list.bullet", withConfiguration: boldConfig)
        button.setImage(boldList, for: .normal)
        button.tintColor = .lightGray
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(pushForScore), for: .touchUpInside)
        return button
    }
    
    private var scoreTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .lightGray
        label.text = "0"
        return label
    }()
    
    private lazy var addThreeCardTitle: UIButton = {
        var button = UIButton()
        
        button = configureButton(backgroundColor: .gray,
                                 cornerRadius: 12,
                                 fontSize: 25,
                                 title: "Add Cards",
                                 titleColor: .black,
                                 masksToBounds: true)
        button.addTarget(self, action: #selector(addThreeCard), for: .touchUpInside)
        return button
    }()
    
    private lazy var newGameTitle: UIButton = {
        var button = UIButton()
        
        button = configureButton(backgroundColor: .gray,
                                 cornerRadius: 12,
                                 fontSize: 25,
                                 title: "New Game",
                                 titleColor: .black,
                                 masksToBounds: true)
        button.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        var stackView = UIStackView()
        
        stackView = configureStackView(axis: .horizontal,
                                       spacing: 20,
                                       alignemnt: .fill,
                                       distribution: .fillEqually)
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        var stackView = UIStackView()
        
        stackView = configureStackView(axis: .horizontal,
                                       spacing: 20,
                                       alignemnt: .fill,
                                       distribution: .fillEqually)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        viewModel.onLoad()
        configureStackViews()
        configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureAutoLayout()
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
}

extension SetViewController { //Private functions
    
    private func bindingScore() {
        viewModel.$score
            .sink { [weak self] score in
                self?.scoreTitle.text = String(describing: score)
            }
            .store(in: &subscriber)
    }
    
    @objc private func newGame() {
        viewModel.newGame()
        bindingScore()
        collectionView?.reloadData()
    }
    
    @objc private func addThreeCard() {
        viewModel.addThreeCard()
        collectionView?.reloadData()
    }
    
    func onCardButton(index: Int) {
        viewModel.select(at: index)
        bindingScore()
        collectionView?.reloadData()
        viewColor(for: viewModel.setChecker,
                  selectedTwice: viewModel.selectedTwice,
                  selectedCard: viewModel.set.selectedCards.count)
    }
    
    @objc private func pushForScore(_ sender: UIButton) {
        let scoreViewController = ScoreViewController()
        self.present(scoreViewController, animated: true, completion: nil)
    }
    
    private func configureStackViews() {
        [self.addThreeCardTitle,
         self.newGameTitle].forEach { buttonStackView.addArrangedSubview($0)}
        
        [.init(),
         self.scoreTitle,
         self.scoreController].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCell.self) )
        collectionView.backgroundColor = UIColor.black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView else { return }
        
        layout.itemSize = CGSize(
            width: collectionView.frame.size.width / 4.5,
            height: collectionView.frame.size.height / 7)
        
        let contentHeight: CGFloat = collectionView.frame.size.height
        let cellHeight: CGFloat = layout.itemSize.height * 6
        let cellSpacing: CGFloat = 10 * 4
        collectionView.contentInset = UIEdgeInsets(top: (contentHeight - cellHeight - cellSpacing) / 2, left: 0, bottom: 0, right: 0)
    }
    
    private func configureAutoLayout() {
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        view.addSubview(labelStackView)
        
        constraints.append(contentsOf: [
            
            labelStackView.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: view.safeAreaInsets.top),
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelStackView.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
            /* For Collection view, we are using center x, which is defined as the view's center X,
             center y as view's center y with constant: view's top safe area multiplied by two, height is defined as 65/100 of the view's height, width as the view's height with constant: view's top safe area */
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                  constant: -(view.safeAreaInsets.top)),
            collectionView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            
            /* For labelStackView, top anchor is connected with Collection View's bottom anchor,
             width is equal to the Collection View, center X is defined as view's center X */
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom),
            buttonStackView.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
        ])
    }
    
    private func viewColor(for set: Bool,selectedTwice: Bool, selectedCard: Int) {
        if set == true && selectedTwice == true && selectedCard == 0 {
            UIView.animate(withDuration: 0.8,
                           delay: 0.3,
                           options: [],
                           animations: {
                self.view.backgroundColor = .systemGreen
                self.collectionView?.backgroundColor = .systemGreen
            }, completion: nil)
            UIView.animate(withDuration: 0.8,
                           delay: 0.3,
                           options: [],
                           animations: {
                self.view.backgroundColor = .black
                self.collectionView?.backgroundColor = .black
            }, completion: nil)
        }
        
        if set == false && selectedTwice == true && selectedCard == 0 {
                UIView.animate(withDuration: 0.8,
                               delay: 0.3,
                               options: [],
                               animations: {
                    self.view.backgroundColor = .systemRed
                    self.collectionView?.backgroundColor = .systemRed
                }, completion: nil)
                UIView.animate(withDuration: 0.8,
                               delay: 0.3,
                               options: [],
                               animations: {
                    self.view.backgroundColor = .black
                    self.collectionView?.backgroundColor = .black
                }, completion: nil)
        }
    }
    
    private func configureButton(backgroundColor: UIColor, cornerRadius: CGFloat, fontSize: CGFloat, title: String, titleColor: UIColor, masksToBounds: Bool) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = masksToBounds
        button.titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
    
    private func configureStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignemnt: UIStackView.Alignment, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignemnt
        stackView.distribution = distribution
        return stackView
        
    }
}

extension SetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self),
                                                            for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell.init() }
        
        cell.configure(delegate: self,
                       cardInfo: viewModel.cardInfoList[indexPath.row],
                       isSet: viewModel.isSet(),
                       isSelected: viewModel.isSelected(at: indexPath.row))
     
        return cell
    }
}

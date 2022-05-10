//
//  ScoreViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 07.03.22.
//

import UIKit
import CoreData

final class ScoreViewController: UIViewController {
    
//    init(viewModel: ScoreViewModel) {
////        super.init(nibName: nil, bundle: nil)
//        self.viewModel = ScoreViewModel(scoreRepository: ScoreRepository(delegate: self))
//        super.init(nibName: nil, bundle: nil)
//
////        viewModel = ScoreViewModel(scoreRepository: ScoreRepository(delegate: self))
//    }
//        
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    private lazy var viewModel = ScoreViewModel(scoreRepository: ScoreRepository(delegate: self))

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ScoreTableViewCell.self, forCellReuseIdentifier: String(describing: ScoreTableViewCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.performFetch()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - Table View
extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ScoreTableViewCell.self),
                                                       for: indexPath) as? ScoreTableViewCell else { return UITableViewCell.init() }
        
        let currentScore = viewModel.score(at: indexPath)
        guard let date = currentScore.date else { return UITableViewCell.init()}
        cell.configure(scoreTitle: "Score: \(currentScore.score)",
                       dateTitle: date,
                       index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            self.viewModel.deleteScore(at: indexPath)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ScoreViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            let cell = tableView.cellForRow(at: indexPath) as! ScoreTableViewCell
            let score = viewModel.score(at: indexPath)
            cell.configure(scoreTitle: "\(score.score)", dateTitle: "\(String(describing: score.date))", index: indexPath.row)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet, with: .automatic)
        default: break
        }
    }
}



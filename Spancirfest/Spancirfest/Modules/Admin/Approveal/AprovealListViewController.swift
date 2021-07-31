//
//  AprovealListViewController.swift
//  Spancirfest
//
//  Created by Dino Martan on 11/07/2021.
//




import UIKit

class AprovealListViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Public properties
    
    //MARK: - Private properties
    
    private var eventApproveals: [EventApproveal] = []
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}

//MARK: - Private extensions -

private extension AprovealListViewController {
    
    //MARK: - View setup
    
    private func setupView() {
        configureTableView()
        fetchApproveals()
    }
    
    //MARK: - TableView configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MyApprovealsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: MyApprovealsTableViewCell.identifier)
    }
    
    //MARK: - Data
    
    private func fetchApproveals() {
        DatabaseHandler.shared.getData(type: EventApproveal.self, collection: .eventApproveal) { eventApproveals in
            self.eventApproveals = eventApproveals
            self.tableView.reloadData()
        } failure: { error in
            Alerter.showOneButtonAlert(on: self, title: .error, message: .dataFetchingFailed, actionTitle: .ok, handler: nil)
        }
    }
    
}

//MARK: - TableView DataSource and Delegate -

extension AprovealListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventApproveals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyApprovealsTableViewCell.identifier) as? MyApprovealsTableViewCell else { return UITableViewCell() }
        cell.configureCell(eventApproveal: eventApproveals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let eventAproveal = eventApproveals[indexPath.row]
        
        // if there is no feedback, admin can approve or deny event
        if eventAproveal.getStatus().status == .awaiting {
            guard let approvealViewController = UIStoryboard.getViewController(viewControllerType: ApprovealViewController.self, from: .Approveal) else{ return }
            approvealViewController.eventApproveal = eventAproveal
            approvealViewController.delegate = self
            present(approvealViewController, animated: true, completion: nil)
        }
        // if feedback is set, admin cannot change it
        else {
            guard let approvealDetailsViewController = UIStoryboard.getViewController(viewControllerType: ApprovealDetailsViewController.self, from: .Approveal) else{ return }
            approvealDetailsViewController.eventApproveal = eventAproveal
            present(approvealDetailsViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}

//MARK: - Approveal Delegate -

extension AprovealListViewController: ApprovealViewControllerDelegate {
    
    func didMakeChanges() {
        fetchApproveals()
    }
    
}

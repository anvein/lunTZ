import UIKit
import Foundation

final class UsersListViewController: UIViewController {

    private let randomUsersService: RandomUserService

    // MARK: - Subviews

    private let refreshControl = UIRefreshControl()
    private let filterView = UsersListFilterView()
    private let tableView = UsersListTableView()

    // MARK: - Data

    private var items: [UserEntity] = []
    private var filteredItems: [UserEntity] = []
    private var tableFilter: UsersListFilterDto = .init(fullNameFilter: nil, emailFilter: nil, withoutDeleted: true)

    // MARK: - Init

    init(randomUsersService: RandomUserService) {
        self.randomUsersService = randomUsersService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Users List"
        setupHierarchy()
        setupConstraints()
        setupView()
        loadData()
    }
}

private extension UsersListViewController {

    // MARK: - Setup

    func setupView() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(handleOnRefreshTable), for: .valueChanged)
        tableView.setRefreshControl(refreshControl)

        filterView.onAnswer = { [weak self] answer in
            self?.handleFilterAnswer(answer)
        }
    }

    func setupHierarchy() {
        view.addSubviews(filterView, tableView)
    }

    // MARK: - Layout

    func setupConstraints() {
        [filterView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Navigation

    func openUserDetail(for item: UserEntity) {
        let viewModel = UserDetailVM(from: item)
        let detailVC = UserDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func showErrorAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "ок", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Actions handlers

    @objc func handleOnRefreshTable() {
        loadData()
    }

    func handleFilterAnswer(_ answer: UsersListFilterView.Answer) {
        switch answer {
        case .onTapClear:
            tableFilter = .init(fullNameFilter: nil, emailFilter: nil, withoutDeleted: true)
            filteredItems = randomUsersService.applyFilter(tableFilter, for: items)
            tableView.reloadData()

        case .onTapApply(let fio, let email):
            tableFilter = .init(fullNameFilter: fio, emailFilter: email, withoutDeleted: true)
            filteredItems = randomUsersService.applyFilter(tableFilter, for: items)
            tableView.reloadData()
        }
    }

    // MARK: - Data

    func loadData() {
        Task { [weak self] in
            guard let self else { return }

            Task { @MainActor in
                if self.filteredItems.isEmpty {
                    self.tableView.setContentOffset(
                        CGPoint(x: 0, y: -self.tableView.refreshControl!.frame.height),
                        animated: true
                    )
                    self.refreshControl.beginRefreshing()
                }
            }

            do {
                let items = try await randomUsersService.fetchUsers(count: 50)
                self.items = items
                self.filteredItems = randomUsersService.applyFilter(tableFilter, for: items)
            } catch {
                self.showErrorAlert(message: "Ошибка загрузки данных")
            }

            Task { @MainActor in
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension UsersListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(UsersListTableCell.self, for: indexPath) else {
            return .init()
        }

        if let item = filteredItems[safe: indexPath.row] {
            cell.fill(from: .init(from: item))
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = filteredItems[safe: indexPath.row] else { return }

        openUserDetail(for: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let filteredItem = filteredItems[safe: indexPath.row] else { return nil }

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }

            randomUsersService.deleteItem(filteredItem)

            if let itemIndex = items.firstIndex(where: { $0.id == filteredItem.id }) {
                items[itemIndex].isDeleted = true
            }
            filteredItems.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

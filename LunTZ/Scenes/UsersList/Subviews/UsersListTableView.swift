import UIKit

final class UsersListTableView: UITableView {

    // MARK: - Init

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        registerCell(UsersListTableCell.self)
        separatorStyle = .singleLine
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Update view

    func setRefreshControl(_ refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
    }
}

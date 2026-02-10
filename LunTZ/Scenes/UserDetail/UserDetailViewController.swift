import UIKit

final class UserDetailViewController: UIViewController {

    // MARK: - Properties

    private let userDetailView = UserDetailView()
    private let viewModel: UserDetailVM

    // MARK: - Init

    init(viewModel: UserDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = userDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User Info"
        userDetailView.fill(from: viewModel)
    }

}

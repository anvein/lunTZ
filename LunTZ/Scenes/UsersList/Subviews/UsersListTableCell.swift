import UIKit

final class UsersListTableCell: UITableViewCell {

    // MARK: - Subviews

    private let avatarImageView = CachedImageView()

    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()

    private let textStackView = UIStackView()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupHierarchy()
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.resetLoadingImage()
    }

    // MARK: - Update view

    func fill(from vm: UsersListCellVM) {
        avatarImageView.loadImage(from: vm.avatarUrl)

        nameLabel.text = vm.fullName
        emailLabel.text = vm.email
        phoneLabel.text = vm.phone
    }
}

private extension UsersListTableCell {

    // MARK: - Setup

    func setupHierarchy() {
        contentView.addSubviews(avatarImageView, textStackView)
        textStackView.addArrangedSubviews(
            nameLabel,
            emailLabel,
            phoneLabel
        )
    }

    func setupView() {
        selectionStyle = .none

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.cornerRadius = 30

        [nameLabel, emailLabel, phoneLabel].forEach {
            $0.numberOfLines = 0
        }

        nameLabel.font = .boldSystemFont(ofSize: 16)
        emailLabel.font = .systemFont(ofSize: 14)
        phoneLabel.font = .systemFont(ofSize: 14)

        textStackView.axis = .vertical
        textStackView.spacing = 4
    }

    func setupConstraints() {
        [avatarImageView, textStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),

            textStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

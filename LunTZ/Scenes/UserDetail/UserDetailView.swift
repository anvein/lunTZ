import UIKit

final class UserDetailView: UIView {

    // MARK: - Subviews

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let photoImageView = CachedImageView()
    private let labelsStackView = UIStackView()

    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let phoneLabel = UILabel()
    private let addressLabel = UILabel()
    private let genderLabel = UILabel()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHierarchy()
        setupView()
        setupConstraints()
    }

    // MARK: - Update view

    func fill(from viewModel: UserDetailVM) {
        photoImageView.loadImage(from: viewModel.avatar)
        nameLabel.text = viewModel.fullName
        emailLabel.text = "Email: \(viewModel.email)"
        phoneLabel.text = "Phone: \(viewModel.phone)"
        addressLabel.text = "Address: \(viewModel.address)"


        if let gender = viewModel.gender {
            genderLabel.text = "Gender: \(gender)"
        } else {
            genderLabel.isHidden = true
        }
    }
}

// MARK: - Setup

extension UserDetailView {

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(photoImageView, labelsStackView)
        labelsStackView.addArrangedSubviews(nameLabel, genderLabel, emailLabel, phoneLabel, addressLabel)
    }

    private func setupView() {
        backgroundColor = .white

        scrollView.alwaysBounceVertical = true

        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 60

        labelsStackView.axis = .vertical
        labelsStackView.spacing = 12

        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0

        [genderLabel, emailLabel, phoneLabel, addressLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.numberOfLines = 0
            $0.textColor = .darkGray
        }
    }

    private func setupConstraints() {
        [scrollView, contentView, photoImageView, labelsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 200),
            photoImageView.heightAnchor.constraint(equalToConstant: 200),

            labelsStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 20),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

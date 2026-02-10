import UIKit

final class UsersListFilterView: UIView {

    enum Answer {
        case onTapClear
        case onTapApply(fio: String?, email: String?)
    }

    var onAnswer: ((Answer) -> Void)?

    // MARK: - Subviews

    private let fioTextField = UITextField()
    private let emailTextField = UITextField()

    private let clearButton = UIButton()
    private let applyButton = UIButton()

    private let mainStackView = UIStackView()
    private let buttonsStackView = UIStackView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
        setupConstraints()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UsersListFilterView {

    // MARK: - Setup

    func setupHierarchy() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(fioTextField, emailTextField, buttonsStackView)
        buttonsStackView.addArrangedSubviews(clearButton, applyButton)
    }

    func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        fioTextField.placeholder = "ФИО"
        fioTextField.addDoneButton(target: self, action: #selector(doneTapped))

        emailTextField.placeholder = "Email"
        emailTextField.addDoneButton(target: self, action: #selector(doneTapped))

        [fioTextField, emailTextField].forEach {
            $0.borderStyle = .roundedRect
        }

        clearButton.tintColor = .systemRed
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.systemRed, for: .normal)
        clearButton.setTitleColor(.systemRed.withAlphaComponent(0.7), for: .highlighted)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 12, bottom: 2, right: 12)
        clearButton.addTarget(self, action: #selector(handleTapClearButton), for: .touchUpInside)

        applyButton.tintColor = .systemBlue
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.systemBlue, for: .normal)
        applyButton.setTitleColor(.systemBlue.withAlphaComponent(0.7), for: .highlighted)
        applyButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 12, bottom: 2, right: 12)
        applyButton.addTarget(self, action: #selector(handleTapApplyButton), for: .touchUpInside)

        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 16

        mainStackView.axis = .vertical
        mainStackView.spacing = 12
    }

    func setupConstraints() {
        [mainStackView, clearButton, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Actions handlers

    @objc private func handleTapClearButton() {
        onAnswer?(.onTapClear)
        fioTextField.text = nil
        emailTextField.text = nil
        endEditing(true)
    }

    @objc private func handleTapApplyButton() {
        onAnswer?(
            .onTapApply(fio: fioTextField.nonEmptyText, email: emailTextField.nonEmptyText)
        )
        endEditing(true)
    }

    @objc private func doneTapped() {
        endEditing(true)
    }
}

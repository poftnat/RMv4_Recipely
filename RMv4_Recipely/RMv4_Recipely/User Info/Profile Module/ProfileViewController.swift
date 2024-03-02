// ProfileViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол-интерфейс вью модуля "Профиль"
protocol ProfileViewControllerProtocol: AnyObject {
    /// метод обновления таблицы
    func reloadTableView()
    /// метод вызова алерта на смену имени
    func showNameEditorAlert()
}

/// Экран данных пользователя
final class ProfileViewController: UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let navigationTitleText = "Profile"
        static let verdanaBoldFontName = "Verdana-Bold"
        static let headerTableViewCellIdentifier = "HeaderTableViewCell"
        static let optionsTableViewCellIdentifier = "OptionsTableViewCell"
        static let alertTitleText = "Change your name and surname"
        static let alertTextFieldPlaceholder = "Name Surname"
        static let okActionText = "Ok"
        static let cancelActionText = "Cancel"
    }

    // MARK: - Visual Components

    private let tableView = UITableView()

    private let profileTitleBarButtonItem: UIBarButtonItem = {
        let label = UILabel()
        label.text = Constants.navigationTitleText
        label.font = UIFont(name: Constants.verdanaBoldFontName, size: 28)
        let item = UIBarButtonItem(customView: label)
        return item
    }()

    // MARK: - Public Properties

    var presenter: ProfilePresenterProtocol?

    // MARK: - Private Properties

    private var user: User?

    private let optionCells: [Profile] = Profile.sendMock()

    private let tableViewSections: [ProfileFieldType] = [
        .header,
        .common
    ]

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = profileTitleBarButtonItem
        setupTableView()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none

        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: Constants.headerTableViewCellIdentifier)
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: Constants.optionsTableViewCellIdentifier)

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        setTableViewConstraints()
    }

    private func setTableViewConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

/// Расширение вью методами протокола-интерфейса ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }

    func showNameEditorAlert() {
        let alert = UIAlertController(title: Constants.alertTitleText, message: nil, preferredStyle: .alert)

        alert.addTextField()
        alert.textFields?.first?.placeholder = Constants.alertTextFieldPlaceholder

        let okAction = UIAlertAction(title: Constants.okActionText, style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text else { return }
            self?.presenter?.changeUserName(name: text)
        }

        let cancelAction = UIAlertAction(title: Constants.cancelActionText, style: .cancel)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.preferredAction = okAction

        present(alert, animated: true)
    }
}

// MARK: - ProfileViewController + UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewSections[section] {
        case .header:
            return 1
        case .common:
            return optionCells.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewSections[indexPath.section] {
        case .header:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.headerTableViewCellIdentifier,
                    for: indexPath
                ) as? HeaderTableViewCell, let user = presenter?.getUserInfo()
            else { return UITableViewCell() }
            cell.configure(user: user)
            cell.editNameHandler = { [weak self] in
                self?.presenter?.editButtonTapped()
            }
            return cell
        case .common:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: Constants.optionsTableViewCellIdentifier,
                    for: indexPath
                ) as? OptionsTableViewCell
            else { return UITableViewCell() }
            cell.configure(option: optionCells[indexPath.row])
            return cell
        }
    }
}

// MARK: - ProfileViewController + UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewSections[indexPath.section] {
        case .header:
            break
        case .common:
            switch optionCells[indexPath.row].type {
            case .bonuses:
                presenter?.bonusesCellTapped()
            default:
                break
            }
        }
    }
}

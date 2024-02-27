// ProfilePresenter.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

protocol ProfilePresenterProtocol {
    /// абстрактный интерфейс
}

/// Презентер модуля "Профиль пользователя"
final class ProfilePresenter {
    weak var view: ProfileViewControllerProtocol?
    weak var coordinator: ProfileCoordinator?
}

extension ProfilePresenter: ProfilePresenterProtocol {
    /// здесь будет имплементация интерфейса в этот класс
}

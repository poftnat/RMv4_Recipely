// RecipesCategories.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Категории рецептов
enum RecipeCategories: String, Codable {
    /// Салаты
    case salad = "Salad"
    /// Супы
    case soup = "Soup"
    /// Курица
    case chicken = "Chicken"
    /// Мясо
    case meat = "Meat"
    /// Рыба
    case fish = "Fish"
    /// Гарниры
    case sideDish = "Side dish"
    /// Напитки
    case drinks = "Drinks"
    /// Блины
    case pancake = "Pancake"
    /// Десерты
    case desserts = "Desserts"
}

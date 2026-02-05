//
//  OnboardingModels.swift
//  OnboardingApp
//
//  Created on 05/11/2025.
//

import Foundation

// MARK: - Search Source Options
enum SearchSource: String, CaseIterable {
    case camera = "Camera"
    case photo = "Photo"
    
    var localizedName: String {
        return self.rawValue
    }
}

// MARK: - Search Goal Options
enum SearchGoal: String, CaseIterable {
    case similarImages = "Find similar images"
    case findPeople = "Identify people or look-alikes"
    case actorName = "Identify celebrities"
    case somethingElse = "Something else"
    case other = "Other"
    
    var localizedName: String {
        return self.rawValue
    }
}

// MARK: - Search Engine
struct SearchEngine: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: String
}


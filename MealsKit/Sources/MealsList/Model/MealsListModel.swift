//
//  MealsListModel.swift
//  
//
//  Created by Raul Mena on 9/8/24.
//

import MealsApi
import Foundation
import SwiftUI

@MainActor
public class MealsListModel: ObservableObject {
    public init(apiClient: MealsApi) {
        self.apiClient = apiClient
        getDesserts()
    }

    @Published var desserts = [Meal]()

    private let apiClient: MealsApi

    private func getDesserts() {
        Task { @MainActor in
            do {
                self.desserts = try await apiClient.getDesserts()
            } catch {
                print("MealsListModel - error fetching desserts: \(error.localizedDescription)")
            }
        }
    }
}
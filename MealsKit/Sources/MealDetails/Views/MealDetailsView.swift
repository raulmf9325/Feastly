//
//  MealDetailsView.swift
//
//
//  Created by Raul Mena on 9/9/24.
//

import MealsApi
import SDWebImageSwiftUI
import SwiftUI

public struct MealDetailsView: View {
    public init(model: MealDetailsModel) {
        self.model = model
    }
    
    @ObservedObject var model: MealDetailsModel
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                        image
                    VStack(alignment: .leading, spacing: 20) {
                        title
                        ingredients
                        watchOnYoutubeButton
                        instructions
                    }
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .ignoresSafeArea()

            backButton
                .padding(.horizontal, 25)
        }
        .toolbar(.hidden)
        .navigationBarBackButtonHidden()
        .sheet(item: $model.sheet) { sheet in
            switch sheet {
            case let .webView(stringURL):
                WatchOnYouTubeView(stringURL: stringURL)
            }
        }
    }

    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundStyle(.white)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.5))
                )
        }
    }

    @ViewBuilder
    var title: some View {
        if let name = model.mealDetails?.name {
            Text(name)
                .font(.title2)
                .bold()
        } else {
            placeholderText
        }
    }

    var watchOnYoutubeButton: some View {
        Button(action: {model.onWatchOnYouTubeButtonTapped()}) {
            HStack {
                Image(systemName: "play.circle")
                    .foregroundStyle(.red)
                    .font(.title2)

                Text("Watch on YouTube")
                    .foregroundStyle(.red)
            }
        }
    }

    @ViewBuilder
    var ingredients: some View {
        if let ingredients = model.mealDetails?.ingredientAmounts {
            VStack(alignment: .leading, spacing: 12) {
                Text("Ingredients")
                    .font(.title3)
                    .bold()
                    .underline()

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(ingredients.sorted(by: <), id: \.key) { ingredient, amount in
                        HStack {
                            Text("\(ingredient):")
                                .bold()
                            Text(amount)
                        }
                        .font(.callout)
                    }
                }
            }
        } else {
            placeholderText
        }
    }

    @ViewBuilder
    var instructions: some View {
        if let instructions = model.mealDetails?.instructions {
            VStack(alignment: .leading, spacing: 15) {
                Text("Instructions")
                    .font(.title3)
                    .bold()
                    .underline()
                Text(instructions)
                    .font(.callout)
            }
        } else {
            placeholderText
        }
    }

    @ViewBuilder
    var image: some View {
        if let imageURL = model.mealDetails?.thumbnailImageURL {
            WebImage(url: URL(string: imageURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } placeholder: {
                Image(systemName: "photo.fill")
                    .font(.system(size: 60))
            }
            .frame(height: 250)
            .clipped()
        } else {
            Image(systemName: "photo.fill")
                .resizable()
                .frame(height: 250)
                .foregroundStyle(.gray)
        }
    }

    var placeholderText: some View {
        Text("""
            Lorem ipsum dolor sit amet, consectetur adipiscing elit\nLorem ipsum dolor sit amet, consectetur adipiscing elit
            """)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    NavigationStack {
        MealDetailsView(model: MealDetailsModel(meal: [Meal].mock[0],
                                                apiClient: .test))
    }
}
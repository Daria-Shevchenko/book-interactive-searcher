//
//  OnboardingView.swift
//  final_final
//
//  Created by Daria Shevchenko on 01.05.2023.
//

import Foundation
import SwiftUI

struct StartView: View {
    // MARK: - Property

    @State private var bWidth: Double = UIScreen.main.bounds.width - 48
    @State private var offset: CGFloat = 0
    @State private var isMoving: Bool = false

    @AppStorage("starting") var isStartViewVisible: Bool = true

    private var textTitle: String = "Bookshelf"
    private var textDetails: String = "Discover your next favorite novel among the stacks of books."

    // MARK: - Body

    var body: some View {
        ZStack {
            Color("ColorStart").ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 22) {
                headerBlock()
                centerBlock()
                swipeButton()
            }
        }
        .onAppear {
            isMoving = true
        }
    }

    @ViewBuilder
    func headerBlock() -> some View {
        Spacer()
        VStack(spacing: 22) {
            Text(textTitle)
                .font(.system(size: 55))
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(textDetails)
                .font(.system(size: 20))
                .fontWeight(.light)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
        }
        .animation(.easeOut(duration: 0.8), value: isMoving)
    }

    @ViewBuilder
    func centerBlock() -> some View {
        ZStack {
            ZStack {
                Image("person-with-book")
                    .resizable()
                    .scaledToFit()
            }
        }
        Spacer()
    }

    @ViewBuilder
    func swipeButton() -> some View {
        ZStack {
            smalllCircles
            Text("Let's start!")
                .font(.caption)
                .foregroundColor(.white)
                .offset(x: 10)

            HStack {
                Capsule()
                    .fill(Color("ColorLightBlue"))
                    .padding(11)
                    .frame(width: offset + 72)
                Spacer()
            }

            HStack {
                buttonSwipe
                Spacer()
            }
        }
        .frame(width: bWidth, height: 82, alignment: .center)
        .opacity(isMoving ? 1 : 0)
        .padding(.bottom, 50)
    }

    @ViewBuilder
    var buttonSwipe: some View {
        ZStack {
            circles
        }
        .padding(10)
        .foregroundColor(.white)
        .frame(width: 78, height: 78, alignment: .center)
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged { elem in
                    if offset <= bWidth - 80, elem.translation.width > 0 { offset = elem.translation.width }
                }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        if offset > bWidth / 1.8 {
                            isStartViewVisible = false
                            offset = bWidth - 80
                        } else { offset = 0 }
                    }
                }
        )
    }

    @ViewBuilder
    var circles: some View {
        Circle()
            .fill(Color("ColorLightBlue"))
        Circle()
            .fill(.black.opacity(0.15))
            .padding(1)
        Image(systemName: "books.vertical.fill")
            .font(.caption)
    }

    @ViewBuilder
    var smalllCircles: some View {
        ZStack {
            Capsule()
                .fill(Color.white.opacity(0.1))
            Capsule()
                .fill(Color.white.opacity(0.1))
                .padding(1)
        }
        .padding(10)
    }
}

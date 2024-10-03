//
//  PopUpAlertView.swift
//  ByVids
//
//  Created by Ega Setya Putra on 02/10/24.
//

import SwiftUI

struct DialogConfiguration {
    let type: DialogType
    let mainButtonDidTap: (() -> Void)?
    let cancelButtonDidTap: (() -> Void)?
}

enum DialogType: Equatable {
    case commonError(message: String)
    case connectionError(message: String)
    case deleteValidation
}

struct DialogView: View {
    let type: DialogType?
    let mainButtonDidTap: (() -> Void)?
    let cancelButtonDidTap: (() -> Void)?

    private var alertMessage: String {
        switch type {
        case .commonError(let message), .connectionError(let message):
            return message
        default:
            return "Are you sure you want to delete this video?"
        }
    }

    private var symbolImageName: String {
        switch type {
        case .commonError:
            return "exclamationmark.circle.fill"
        case .connectionError:
            return "wifi.slash"
        default:
            return "questionmark.diamond.fill"
        }
    }

    private var buttonTitle: String {
        switch type {
        case .commonError, .connectionError:
            return "RETRY"
        default:
            return "YES"
        }
    }

    private var buttonColor: Color { .pink }

    var body: some View {
        ZStack {
            if type == .deleteValidation {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        cancelButtonDidTap?()
                    }
            }

            VStack(spacing: 20) {
                Image(systemName: symbolImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                    .foregroundColor(.pink)

                Text(alertMessage)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)

                Button(action: {
                    mainButtonDidTap?()
                }) {
                    Text(buttonTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonColor)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                if type == .deleteValidation {
                    Button(action: {
                        cancelButtonDidTap?()
                    }) {
                        Text("CANCEL")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .if(type == .deleteValidation) { view in
                view
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.horizontal, 40)
            }
        }
    }
}

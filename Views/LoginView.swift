//
//  LoginView.swift
//  Cash Out mini
//
//  Created by Gergo Huber on 2024. 10. 27..
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isUserLoggedIn: Bool
    @Binding var userName: String?
    
    var body: some View {
            VStack(spacing: 20) {
                Text("Sign in to continue")
                    .font(.title)

                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName]
                    },
                    onCompletion: handleAuthorization
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding()
            }
        }

        private func handleAuthorization(result: Result<ASAuthorization, Error>) {
            switch result {
            case .success(let authResults):
                if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                    print(credential)
                    userName = credential.fullName?.givenName ?? credential.fullName?.familyName ?? "User"
                    isUserLoggedIn = true
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                print("Authorization failed: \(error.localizedDescription)")
            }
        }
}

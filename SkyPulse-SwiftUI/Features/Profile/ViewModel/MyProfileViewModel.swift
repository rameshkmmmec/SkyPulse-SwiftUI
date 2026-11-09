//
//  MyProfileViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 09/11/26.
//

import Foundation
import Combine

final class MyProfileViewModel: ObservableObject {
    
    @Published var avatarURL: String = ""
    @Published var fullname: String = ""
    @Published var emailText: String = ""
    @Published var mobileText: String = ""
    @Published var addressText: String = ""
    @Published var isFieldEditable: Bool = false
    
    init(avatarURL: String, fullname: String, emailText: String, mobileText: String, addressText: String) {
        self.avatarURL = avatarURL
        self.fullname = fullname
        self.emailText = emailText
        self.mobileText = mobileText
        self.addressText = addressText
    }
}

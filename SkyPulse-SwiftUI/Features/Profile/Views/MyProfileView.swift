//
//  MyProfileView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import SwiftUI

struct MyProfileView: View {
    
    @StateObject var vm: MyProfileViewModel
    @Environment(AuthManager.self) private var auth

    init(user: User) {
        _vm = StateObject(wrappedValue: MyProfileViewModel(avatarURL: user.avatarURL, fullname: user.name, emailText: user.email, mobileText: user.phone, addressText: user.address))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 35) {
            
            Text("My Profile")
                .fontPoppins(size: 20, weight: .medium, color: .black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ZStack(alignment: .top) {
                if !vm.isFieldEditable {
                    Button {
                        vm.isFieldEditable = true
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "pencil")
                                .fontPoppins(size: 18, weight: .bold, color: .black)
                            Text("Edit")
                                .fontPoppins(size: 15, weight: .medium, color: .black)
                        }
                        .padding(.leading, 140)
                    }
                }
                
                CachedAsyncImage(url: URL(string: vm.avatarURL), contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            ProfileTextField(text: $vm.fullname, title: "", placeholder: "", vm: vm)
            
            ProfileTextField(text: $vm.emailText, title: "", placeholder: "", vm: vm)

            ProfileTextField(text: $vm.mobileText, title: "", placeholder: "", vm: vm)

            ProfileTextField(text: $vm.addressText, title: "", placeholder: "", vm: vm)
            
            if vm.isFieldEditable {
                Button {
                    vm.isFieldEditable = false
                } label: {
                    Text("Update")
                        .fontPoppins(size: 16, weight: .bold, color: .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            Capsule()
                                .fill(
                                    AnyShapeStyle(LinearGradient.skyPrimary())
                                )
                        )
                        .padding(.vertical, 10)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

struct ProfileTextField: View {
    
    @Binding var text: String
    let title: String
    var placeholder: String = ""
    @StateObject var vm: MyProfileViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
                        
            TextField(placeholder.isEmpty ? title : placeholder, text: $text)
                .fontPoppins(size: 17, weight: .regular, color: .black.opacity(0.75))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .disabled(!vm.isFieldEditable)
            
            Rectangle()
                .fill(.gray.opacity(0.25))
                .frame(height: 1)
        }
    }
}

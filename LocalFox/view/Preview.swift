//
//  Preview.swift
//  LocalFox
//
//  Created by venkatesh karra on 01/07/23.
//

import SwiftUI

//
//  ProfileImageView.swift
//  LocalFox
//
//  Created by venkatesh karra on 28/02/23.
//

import SwiftUI
struct Preview: View {
    var imageName:String
    @State private var showErrorSnackbar: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Color.clear.overlay(
                    AsyncImage(url: URL(string: imageName)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()    // << for image !!
                        default:
                            ProgressView()
                        }
                    }
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit) // << for square !!
                .clipped()
        }
        .background(Color.SCREEN_BG.ignoresSafeArea())
        .setNavTitle("", showBackButton: true,leadingSpace: 20)
    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        Preview(imageName: "https://localfox-job-photos.s3.ap-southeast-2.amazonaws.com/jobImage_649818509660020abae6a5b2_1687689319557.jpeg")
    }
}

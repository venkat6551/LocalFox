//
//  InvitationsListView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/13/23.
//

import SwiftUI

struct InvitationsListView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
    @State private var invitations: [String] = ["Mario", "Luigi", "Peach", "Toad", "Daisy"]
    @State var count :Int = 0
    
    var body: some View {
        ZStack {
            ForEach(invitations, id: \.self) { invitation in
                InvitationView { accepted in
                    count = count+1
                }
            }
        }
        .onChange(of: count) { newValue in
            if(count == self.invitations.count) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
     func remove(item:String) {
        invitations = invitations.filter { $0 != item }
    }
    
}

struct InvitationsListView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationsListView()
    }
}

//
//  UI.swift
//  Hapag-Lloyd
//
//  Created by Meet Vora on 2022-07-13.
//

import Foundation
import SwiftUI
import Combine


extension View {
    func bottomSheet<Content>(
        show: Binding<Bool>,
        title: String,
        doneButtonText: String? = nil,
        doneButtonDisabled: Bool = false,
        onClickDone: (() -> Void)? = nil,
        @ViewBuilder sheetContentView: @escaping () -> Content
    ) -> some View where Content : View {
        return ZStack {
            self
                .blur(radius: show.wrappedValue ? 3 : 0)
            if show.wrappedValue {
                Color.gray
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        show.wrappedValue = false
                    }
                VStack(spacing: 0) {
                    Spacer()
                    BottomSheetView(
                        show: show,
                        title: title,
                        doneButtonText: doneButtonText,
                        doneButtonDisabled: doneButtonDisabled,
                        onClickDone: onClickDone,
                        sheetContentView: sheetContentView
                    )
                }.ignoresSafeArea(SafeAreaRegions.container, edges: Edge.Set.bottom)
            }
        }
    }
    
    func cardify(
        contentPadding: CGFloat = 0,
        cardBgColor: Color = Color.white,
        borderColor: Color = Color.LINES,
        cardCornerRadius: CGFloat = Dimens.CARD_CORNER_RADIUS_DEFAULT,
        corners: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
    ) -> some View {
        return self
            .compositingGroup() // fixes nested clipping shape padding issues
            .padding(contentPadding)
            .clipShape(RoundedCorner(radius: cardCornerRadius, corners: corners))
            .background(
                RoundedCorner(radius: cardCornerRadius, corners: corners)
                    .fill(cardBgColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .stroke(borderColor, lineWidth: Dimens.INPUT_FIELD_BOX_OUTLINE_WIDTH)
            )
    }
    
    func snackbar(
        show: Binding<Bool>,
        snackbarType: SnackBarType = SnackBarType.error,
        title: String?,
        message: String?,
        secondsAfterAutoDismiss: SnackBarDismissDuration = SnackBarDismissDuration.normal,
        onClickDetails: (() -> Void)? = nil ,
        onSnackbarDismissed: @escaping (() -> Void),
        showDismissButton: Bool = false,
        isAlignToBottom: Bool = true
    ) -> some View {
        return ZStack {
            self
            VStack(spacing: 0) {
                if isAlignToBottom { Spacer() }
                SnackBarView(
                    show: show,
                    snackbarType: snackbarType,
                    title: title,
                    message: message,
                    secondsAfterAutoDismiss: secondsAfterAutoDismiss,
                    onClickDetails: onClickDetails,
                    showDismissButton: showDismissButton,
                    onSnackbarDismissed: onSnackbarDismissed
                )
                if !isAlignToBottom { Spacer() }
            }
        }
    }
    
    func applyShadow() -> some View {
        return self.shadow(color: Color.CARD_DROP_SHADOW, radius: Dimens.CARD_SHADOW, x: 0, y: 3)
    }
    
    // Sets custom top-navigation bar title
    func setNavTitle(
        _ title: String,
        subtitle: String? = nil,
        showBackButton: Bool = false,
        onClickBack: (() -> Void)? = nil,
        trailingView: AnyView? = nil,
        leadingSpace: CGFloat = 40
    ) -> some View {
        return VStack (spacing: 0) {
            ZStack {
                VStack (alignment: .leading,spacing: 5){
                    HStack {
                        if showBackButton {
                            HStack {
                                BackButton(onClickBack: onClickBack)
                                    .padding(.top, 5)
                                Spacer()
                            }
                        }
                        
                    }
                    HStack {
                        Text(title).applyFontHeader()
                        Spacer()
                        if let trailingView = trailingView {
                            trailingView.padding(.trailing, 8)
                        }
                    }.padding(.top, 8)
                    if let subtitle = subtitle {
                        HStack {
                            Text(subtitle).applyFontRegular(color: .TEXT_LEVEL_2,size: 16)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(5)
                                .padding(.trailing,40)
                            
                        }
                    }
                    Spacer()
                }
            }
            .padding(.leading,leadingSpace)
            .frame(maxHeight:(subtitle == nil) ? Dimens.TOP_BAR_HEIGHT : 180)
            ZStack {
                Color.SCREEN_BG
                self
            }
        }
        .navigationBarHidden(true)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
    
    // Sets custom top-navigation bar title that does not go back
    func setNavTitleCustomBack(
        _ title: String,
        showBackButton: Bool = false,
        onClickBack: (() -> Void)? = nil,
        trailingView: AnyView? = nil
    ) -> some View {
        return VStack (spacing: 0) {
            ZStack {
                if showBackButton {
                    HStack {
                        BackButtonOnlyClickBack(onClickBack: onClickBack)
                        Spacer()
                    }
                }
                HStack (spacing: 0) {
                    Spacer()
                    Text(title).applyFontHeader()
                    Spacer()
                }
                if let trailingView = trailingView {
                    HStack {
                        Spacer()
                        trailingView
                    }
                }
            }
            .padding(.horizontal, Dimens.SCREEN_HORIZONTAL_PADDING)
            .frame(maxHeight: Dimens.TOP_BAR_HEIGHT)
            ZStack {
                Color.SCREEN_BG
                self
            }
        }
        .navigationBarHidden(true)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
    
#if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
#endif
    
    
}
struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
struct MyButton: View {
    
    var leadingImage: Image?
    var text: String
    var onClickButton: () -> Void
    var showLoading: Bool = false
    var width: CGFloat = Dimens.BUTTON_MIN_WIDTH
    var trailingImage: Image?
    var outlinedStyle: Bool = false
    var bgColor: Color = Color.SECONDARY
    @Environment(\.isEnabled) private var isEnabled
    
    private let buttonleadingIconSize: CGFloat = 15
    
    var body: some View {
        let buttonDesign =
        HStack(spacing: Dimens.SPACING_DEFAULT) {
            if showLoading {
                ProgressView()
                    .scaleEffect(1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: outlinedStyle ? Color.PRIMARY : Color.white))
            } else if let leadingImage = leadingImage {
                leadingImage
                    .resizable()
                    .colorMultiply(isEnabled ? (outlinedStyle ? Color.PRIMARY : Color.white) : Color.DISABLED_BG)
                    .scaledToFit()
                    .frame(height: buttonleadingIconSize)
                    .foregroundColor(isEnabled ? (outlinedStyle ? Color.PRIMARY : Color.white) : Color.DISABLED_TEXT)
            }
            Text(text)
                .applyFontBold(color: (isEnabled ? (outlinedStyle ? Color.PRIMARY : Color.white) : Color.DISABLED_TEXT), size: 14)
                .frame(height: Dimens.BUTTON_HEIGHT)
            if let trailingImage = trailingImage {
                trailingImage
                    .resizable()
                    .colorMultiply(isEnabled ? Color.white : Color.DISABLED_BG)
                    .scaledToFit()
                    .frame(height: buttonleadingIconSize)
                    .foregroundColor(isEnabled ? (outlinedStyle ? Color.PRIMARY : Color.white) : Color.DISABLED_TEXT)
            }
        }
        .frame( maxWidth: .infinity, idealHeight: Dimens.BUTTON_HEIGHT, alignment: .center)
        .padding(Dimens.BUTTON_PADDING)
        .background(isEnabled ? (outlinedStyle ? Color.white : bgColor) : (outlinedStyle ? Color.white : Color.DISABLED_BG))
        .overlay(
            Capsule()
                .stroke(isEnabled ? Color.PRIMARY : Color.DISABLED_BG, lineWidth: outlinedStyle ? Dimens.INPUT_FIELD_BOX_OUTLINE_WIDTH : 0)
        )
        .cardify(borderColor: Color.clear)
        if showLoading { buttonDesign }
        else {
            Button(
                action: {
                    onClickButton()
                },
                label: {
                    buttonDesign
                }
            )
        }
    }
}

// TextLimiter to allow user to enter certain number characters only
// Reference: https://programmingwithswift.com/swiftui-textfield-character-limit/
class TextLimiter: ObservableObject {
    var limit: Int = -1 // -1 means no limit
    
    init(limit: Int = -1, value: String = "") {
        self.limit = limit
        self.value = value
    }
    
    @Published var value = "" {
        didSet {
            if self.limit != -1 {
                if value.count > self.limit {
                    DispatchQueue.main.async { // keeps user from typing more than 16 characters
                        self.value = String(self.value.prefix(self.limit))
                        self.hasReachedLimit = true
                    }
                } else {
                    self.hasReachedLimit = false
                }
            }
        }
    }
    @Published var hasReachedLimit = false
}


struct MyInputTextBox: View {
    
    var hintText: String = ""
    @Binding var text: String
    var keyboardType = UIKeyboardType.default
    var isPassword: Bool = false
    var autocapitalizationType: UITextAutocapitalizationType = UITextAutocapitalizationType.sentences
    var disableAutocorrection: Bool = true
    var isInputError: Bool = false
    var isFirstResponder: Bool = false
    var leadingImage:Image?
    
    var leadingText:String?
    
    @Environment(\.isEnabled) private var isEnabled
    @State private var isSecured: Bool = true
    @State private var isTextFocused: Bool = false
    @FocusState var isFocused: Bool
    var inputTextColor: Color { isTextFocused ? isInputError ? Color.ERROR : Color.PRIMARY : isInputError ? Color.ERROR : Color.DEFAULT_TEXT
    }
    
    var inputBoxColor: Color { isInputError ? Color.ERROR : Color.LINES}
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 3) {
                if(!hintText.isEmpty) {
                    Text(hintText).applyFontRegular(color: .TEXT_LEVEL_3,size: 16)
                }
                HStack(spacing: 0) {
                    if !isPassword {
                        HStack(spacing: Dimens.SPACING_LOW) {
                            if let leadingImage = leadingImage {
                                leadingImage
                            }
                            if let leadingText = leadingText {
                                Text(leadingText).applyFontRegular(size: 16).padding(.horizontal,10)
                            }
                            TextField("", text: $text, onEditingChanged: { (editingChanged) in
                                DispatchQueue.main.async {
                                    isTextFocused = editingChanged
                                }
                            })
                            .focused($isFocused)
                            .font(Font.custom("Inter-Regular", size: 16))
                            .applyFontSubheading(color: Color.DEFAULT_TEXT)
                            .keyboardType(keyboardType)
                            .autocorrectionDisabled(true)
                            .autocapitalization(autocapitalizationType)
                            .frame(height: Dimens.INPUT_FIELD_HEIGHT)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.leading, .trailing], 4)
                            .textContentType(.oneTimeCode)
                            if isInputError {
                                Images.WARNING_ROUNDED
                                    .applyFontRegular(color: Color.ERROR,size: 16)
                            }
                        }
                    } else {
                        if isSecured {
                            HStack(spacing: Dimens.SPACING_LOW) {
                                if let leadingImage = leadingImage {
                                    leadingImage
                                }
                                if let leadingText = leadingText {
                                    Text(leadingText).applyFontRegular(size: 14).padding(.horizontal,10)
                                }
                                SecureField("", text: $text)
                                    .focused($isFocused)
                                    .applyFontSubheading()
                                    .autocapitalization(UITextAutocapitalizationType.none)
                                    .frame(height: Dimens.INPUT_FIELD_HEIGHT)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding([.leading, .trailing], 4)
                                    .disableAutocorrection(true)
                                    .font(Font.custom("Inter-Regular", size: 16))
                            }
                            
                        } else {
                            HStack {
                                if let leadingImage = leadingImage {
                                    leadingImage
                                }
                                if let leadingText = leadingText {
                                    Text(leadingText).applyFontRegular(size: 14).padding(.horizontal,10)
                                }
                                TextField("", text: $text)
                                    .focused($isFocused)
                                    .applyFontSubheading()
                                    .autocapitalization(UITextAutocapitalizationType.none)
                                    .disableAutocorrection(true)
                                    .frame(height: Dimens.INPUT_FIELD_HEIGHT)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(Font.custom("Inter-Regular", size: 16))
                            }
                        }
                        Button(
                            action: { isSecured.toggle() },
                            label: {
                                (!self.isSecured ? Images.EYE: Images.EYE_SLASH)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18,height: 18)
                                    .accentColor(.gray)
                            }
                        )
                    }
                }
                .padding(.horizontal,Dimens.INPUT_FIELD_BOX_CONTENT_PADDING)
                .clipShape(RoundedRectangle(cornerRadius: Dimens.CARD_CORNER_RADIUS_DEFAULT))
                .overlay(
                    RoundedRectangle(cornerRadius: Dimens.CARD_CORNER_RADIUS_DEFAULT)
                        .stroke(inputBoxColor, lineWidth: Dimens.INPUT_FIELD_BOX_OUTLINE_WIDTH)
                )
                .cardify()
            }
        }
    }
}

enum SnackBarType {
    case normal
    case error
    case success
    
    var icon: Image? {
        switch self {
        case .normal: return nil
        case .error: return Images.ERROR_TICK
        case .success: return Images.SUCCESS_TICK
        }
    }
    var textColor: Color {
        switch self {
        case .normal: return Color.PRIMARY
        case .error: return Color.ERROR_SNEAKBAR_TEXT_COLOR
        case .success: return Color.SUCCESS_SNEAKBAR_TEXT_COLOR
        }
    }
    var bgColor: Color {
        switch self {
        case .normal: return Color.PRIMARY_BG
        case .error: return Color.ERROR_BG
        case .success: return Color.SUCCESS_BG
        }
    }
}
enum SnackBarDismissDuration {
    case normal
    case long
    case never
    
    var duration: Double {
        switch self {
        case .normal: return 2
        case .long: return 10
        case .never: return -1
        }
    }
}
fileprivate struct SnackBarView: View {
    
    @Binding var show: Bool
    var snackbarType: SnackBarType
    var title: String?
    var message: String?
    var secondsAfterAutoDismiss: SnackBarDismissDuration = SnackBarDismissDuration.normal
    var onClickDetails: (() -> Void)?
    var showDismissButton: Bool = false
    var onSnackbarDismissed: (() -> Void)
    
    private static let SNACKBAR_LEADING_ICON_SIZE: CGFloat = 20.0
    @State private var hideSnackBarDispatchWorkerItem: DispatchWorkItem?
    
    var body: some View {
        if show {
            HStack(spacing: Dimens.SPACING_HIGH) {
                if let leadingIcon = snackbarType.icon {
                    leadingIcon
                        .resizable()
                        .applyFontRegular(color: snackbarType.textColor,size: 16)
                        .frame(width: SnackBarView.SNACKBAR_LEADING_ICON_SIZE, height: SnackBarView.SNACKBAR_LEADING_ICON_SIZE)
                        .padding(.leading, 5)
                }
                VStack(alignment: .leading, spacing: Dimens.SPACING_LOW) {
                    if let title = title {
                        Text(title)
                            .bold()
                            .applyFontSubheadingMedium(color: snackbarType.textColor)
                    }
                    if let message = message {
                        Text(message)
                            .applyFontRegular(color: snackbarType.textColor,size: 14)
                            // .applyFontRegular(size: 14)
                    }
                }
                Spacer()
                if let onClickDetails = onClickDetails {
                    Button(action: {
                        onClickDetails()
                    }) {
                        if !showDismissButton {
                            Text(Strings.VIEW)
                                .applyFontSubheadingMedium(color: snackbarType.textColor)
                        } else {
                            Text(Strings.DISMISS)
                                .applyFontSubheadingMedium(color: snackbarType.textColor)
                        }
                    }
                    Spacer()
                }
            }
            .cardify(
                contentPadding: Dimens.SNACKBAR_PADDING_INSIDE,
                cardBgColor: snackbarType.bgColor,
                cardCornerRadius: Dimens.CARD_CORNER_RADIUS_DEFAULT
            )
            .padding(Dimens.SNACKBAR_PADDING_OUTSIDE)
            .onAppear(perform: {
                startAutoDismissSnackbarTimer()
            })
            .onDisappear(perform: {
                stopAutoDismissSnackbarTimer()
            })
            .onChange(of: message, perform: { _ in
                // onAppear will not get called in the case when for example a snackbar is shown for 10 seconds, and you display another snackbar after 5 seconds. In that case, this onChange method will be called to again start timer from fresh 10 seconds.
                startAutoDismissSnackbarTimer()
            })
        } else {
            EmptyView()
        }
    }
    
    private func hideSnackbar() {
        show = false
        onSnackbarDismissed()
        stopAutoDismissSnackbarTimer()
    }
    
    private func startAutoDismissSnackbarTimer() {
        if secondsAfterAutoDismiss == SnackBarDismissDuration.never { return }
        // Dismiss snackbar UI after secondsAfterAutoDismiss value
        stopAutoDismissSnackbarTimer()
        hideSnackBarDispatchWorkerItem = DispatchWorkItem {
            show = false
            onSnackbarDismissed()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsAfterAutoDismiss.duration, execute: hideSnackBarDispatchWorkerItem!)
    }
    
    private func stopAutoDismissSnackbarTimer() {
        hideSnackBarDispatchWorkerItem?.cancel() // dismiss previous timer if any
    }
    
    
}


fileprivate struct BottomSheetView<Content: View>: View {
    
    @Binding var show: Bool
    var title: String
    var doneButtonText: String?
    var doneButtonDisabled: Bool = false
    var onClickDone: (() -> Void)?
    @ViewBuilder var sheetContentView: () -> Content
    
    var body: some View {
        if show {
            VStack(spacing: 0) {
                ZStack {
                    if doneButtonText != nil {
                        HStack {
                            Button(action: { show = false }, label: {
                                Text(Strings.CANCEL).applyFontSubheading(color: Color.PRIMARY)
                            })
                            Spacer()
                        }
                    }
                    Text(title)
                        .applyFontBodyMedium()
                    HStack {
                        Spacer()
                        if let doneButtonText = doneButtonText {
                            Button(action: {
                                show = false
                                onClickDone?()
                            }, label: {
                                Text(doneButtonText)
                                    .applyFontSubheading(color: doneButtonDisabled ? Color.DISABLED_TEXT : Color.PRIMARY)
                            }).disabled(doneButtonDisabled)
                        } else {
                            Button(action: {
                                show = false
                            }) {
                                VStack {
                                    Images.CLOSE
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 12,height: 12)
                                } .frame(width: 34,height: 34)
                                    .cardify(cardCornerRadius: 15)
                                    .background(Color.SCREEN_BG)
                            }
                        }
                    }
                }
                
                .padding(Dimens.BOTTOM_SHEET_TITLE_SECTION_PADDING)
                sheetContentView()
                    .padding(.horizontal, Dimens.BOTTOM_SHEET_CONTENT_SECTION_PADDING)
                Spacer()
                    .frame(maxHeight: 20)
            }.background(Color.SCREEN_BG)
                .cardify(cardCornerRadius: 10,corners: [UIRectCorner.topLeft, UIRectCorner.topRight])
            
        } else {
            EmptyView()
        }
    }
}
struct MySearchBox: View {
    var hintText: String = Strings.SEARCH
    @Binding var text: String
    @FocusState var isFocused: Bool
    var keyboardType = UIKeyboardType.default
    @Environment(\.isEnabled) private var isEnabled
    
    var body: some View {
        VStack(alignment: .leading, spacing: Dimens.SPACING_LOW) {
            HStack(spacing: Dimens.SPACING_LOW) {
                Images.SEARCH
                TextField("", text: $text)
                    .focused($isFocused)
                    .applyFontRegular(size: 14)
                    .keyboardType(keyboardType)
                    .disableAutocorrection(true)
                    .frame(height: Dimens.INPUT_FIELD_HEIGHT)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.leading, .trailing], 4)
                    .placeholder(when: text.isEmpty) {
                        Text(hintText).foregroundColor(.gray)
                            .padding(.leading,5)
                    }
            }
            .padding(Dimens.SEARCH_BAR_PADDING)
        }
        .padding(.horizontal, 10)
        .background(Color.white)
        .cardify()
    }
}

fileprivate struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

class RemoteImageURL: ObservableObject {
    @Published var data = Data()
    
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}

struct BackButton: View {
    
    var onClickBack: (() -> Void)? = nil
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss() // Go back
            onClickBack?()
        }) {
            Images.BACK
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.BACK_ICON_SIZE, height: Dimens.BACK_ICON_SIZE)
            
        }
    }
    
}

// use this back button when you want a custom back naviation Ex: Changing pin
struct BackButtonOnlyClickBack: View {
    
    var onClickBack: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            onClickBack?()
        }) {
            Images.BACK
                .resizable()
                .scaledToFit()
                .frame(width: Dimens.BACK_ICON_SIZE, height: Dimens.BACK_ICON_SIZE)
                .applyShadow()
        }
    }
    
}

struct UI_Previews: PreviewProvider {
    
    @State static private var sampleInputText: String = "21321312313"
    
    // Make below show_ variables to true each at one time to reveal the snackbar on preview
    @State static private var showNormalSnackbar: Bool = true
    @State static private var showErrorSnackbar: Bool = false
    @State static private var showSuccessSnackbar: Bool = false
    
    @State static private var showBottomSheet: Bool = false
    @State static private var isFABExpanded: Bool = true
    
    static var previews: some View {
        NavigationView{
            VStack(spacing: Dimens.SPACING_HIGH) {
                Group {
                    MyButton(
                        leadingImage: Images.ERROR,
                        text: "MyButton",
                        onClickButton: {
                            
                        }
                    )
                    MyInputTextBox(
                        hintText: "Enter any text here",
                        text: $sampleInputText
                    )
                    MySearchBox(
                        hintText: "Search",
                        text: $sampleInputText
                    )
                }
                Spacer()
            }
            .snackbar(
                show: $showNormalSnackbar,
                snackbarType: SnackBarType.success,
                title: "SnackBarType.success",
                message: "Invalid username or password. Please try again later.",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
            .snackbar(
                show: $showErrorSnackbar,
                snackbarType: SnackBarType.error,
                title: "SnackBarType.error",
                message: "Invalid username or password. Please try again later.",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {  },
                isAlignToBottom: true
            )
            .snackbar(
                show: $showSuccessSnackbar,
                snackbarType: SnackBarType.success,
                title: "SnackBarType.success",
                message: "Invalid username or password. Please try again later.",
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: { },
                isAlignToBottom: true
            )
        }
        .previewDevice("iPhone Xs")
    }
}

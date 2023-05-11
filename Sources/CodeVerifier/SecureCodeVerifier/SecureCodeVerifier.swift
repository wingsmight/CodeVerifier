//
//  SecureCodeVerifier.swift
//  CodeVerifier
//
//  Created by MUSOLINO Antonino on 03/03/2020.
//

import SwiftUI

public struct SecureCodeVerifier: View {
    private let style = Styles.defaultStyle

    @State private var insertedCode: String = ""
    @State private var isTextFieldFocused: Bool = false

    @StateObject private var viewModel: SecureCodeVerifierViewModel

    /// The size of the SecureCodeVerifier
    private var textfieldSize: CGSize = .zero

    private var action: ((Bool) -> Void)?
    private var editing: ((String) -> Void)?

    public init(code: String) {
        _viewModel = StateObject(wrappedValue: SecureCodeVerifierViewModel(code: code))
        let height = style.labelHeight + style.lineHeight + style.carrierSpacing
        let width = (style.labelWidth * CGFloat(code.count)) + (style.labelSpacing * CGFloat(code.count - 1))
        textfieldSize = CGSize(width: width, height: height)
    }

    public var body: some View {
        CodeView(fields: viewModel.fields)
            .background(
                SecureTextfield(text: $insertedCode, isFocusable: $isTextFieldFocused, labels: viewModel.fieldNumber)
                    .opacity(0.0)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldFocused.toggle()
            }
            .frame(width: textfieldSize.width, height: textfieldSize.height)
            .padding()
            .onChange(of: insertedCode) { newValue in
                viewModel.buildFields(for: newValue)
                editing?(newValue)
            }
            .onReceive(viewModel.$codeCorrect.dropFirst()) { value in
                action?(value)
            }
    }
}

public extension SecureCodeVerifier {
    func onCodeFilled(perform action: ((Bool) -> Void)?) -> Self {
        var copy = self
        copy.action = action
        return copy
    }

    func onEdit(perform action: ((String) -> Void)?) -> Self {
        var copy = self
        copy.editing = action
        return copy
    }

    @available(*, deprecated, message: "Use the environment injection instead. This modifier does nothing.")
    func withStyle(_: SecureCodeStyle) -> Self {
        self
    }
}

struct SecureCodeVerifier_Previews: PreviewProvider {
    static var previews: some View {
        SecureCodeVerifier(code: "123456")
    }
}

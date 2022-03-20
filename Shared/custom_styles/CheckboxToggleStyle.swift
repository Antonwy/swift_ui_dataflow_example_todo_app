//
//  CheckboxToggleStyle.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  @Environment(\.isEnabled) var isEnabled

  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle() // toggle the state binding
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
          .imageScale(.large)
        configuration.label
      }
    })
    .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
    .disabled(!isEnabled)
  }
}

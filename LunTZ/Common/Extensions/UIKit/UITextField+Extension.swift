import UIKit

extension UITextField {
    var nonEmptyText: String? {
        guard let text = self.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        return text
    }

    func addDoneButton(target: Any, action: Selector) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: target, action: action)

        toolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
}

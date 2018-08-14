import UIKit

open class CodeInputView: UIView, UIKeyInput {
    open var delegate: CodeInputViewDelegate?
    private var nextTag = 1
    static let OTP_LENGTH = 4
    static let NUMBER_WIDTH = 50
    static let NUMBER_SPACE = 15
    static let INPUT_HEIGHT = 60
    static let FONT_SIZE = 42

    // MARK: - UIResponder

    open override var canBecomeFirstResponder : Bool {
        return true
    }

    // MARK: - UIView

    public override init(frame: CGRect) {
        super.init(frame: frame)

        // Add six digitLabels
        var frame = CGRect(x: 15, y: 10, width: 35, height: 40)
        for index in 1...CodeInputView.OTP_LENGTH {
            let digitLabel = UILabel(frame: frame)
            digitLabel.font = .systemFont(ofSize: CGFloat(CodeInputView.FONT_SIZE))
            digitLabel.textColor = UIColor.init(argb: Colors.lightBlue)
            digitLabel.tag = index
            digitLabel.text = "_"
            digitLabel.textAlignment = .center
            addSubview(digitLabel)
            frame.origin.x += CGFloat(CodeInputView.NUMBER_WIDTH)
        }
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(onTapGesture))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func onTapGesture(_ sender: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

    // MARK: - UIKeyInput

    public var hasText : Bool {
        return nextTag > 1 ? true : false
    }

    open func insertText(_ text: String) {
        if nextTag < CodeInputView.OTP_LENGTH + 1 {
            let label = viewWithTag(nextTag)! as! UILabel
            label.text = text
            label.textColor = UIColor.white
            nextTag += 1

            if nextTag == CodeInputView.OTP_LENGTH + 1 {
                var code = ""
                for index in 1..<nextTag {
                    code += (viewWithTag(index)! as! UILabel).text!
                }
                self.resignFirstResponder()
                if (delegate != nil) {
                    delegate?.codeInputView(self, didFinishWithCode: code)
                }
            }
        }
    }

    open func deleteBackward() {
        if nextTag > 1 {
            nextTag -= 1
            let label = viewWithTag(nextTag)! as! UILabel
            label.text = "_"
            label.textColor = UIColor.init(argb: Colors.lightBlue)
        }
    }

    open func clear() {
        while nextTag > 1 {
            deleteBackward()
        }
    }

    // MARK: - UITextInputTraits

    open var keyboardType: UIKeyboardType { get { return .numberPad } set { } }
}

public protocol CodeInputViewDelegate {
    func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String)
}

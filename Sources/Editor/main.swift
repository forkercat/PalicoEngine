import Palico

import MathLib

// Log
Log.registerLogger(name: "Editor", level: .trace)

let app = EditorApp(name: "Editor", arguments: CommandLine.arguments)
app.run()
var v: Float4

let r: Rect

var m: Float4x4 = Float4x4()

let b = Rect(left: 1, right: 1, bottom: 1, top: 1)


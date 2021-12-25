import Palico
import MathLib

// Log
Log.registerLogger(name: "Editor", level: .trace)

let app = EditorApp(name: "Palico Engine", arguments: CommandLine.arguments)
app.run()

Log.info("Exit(0)")

//
//  main.swift
//  Editor
//
//  Created by Junhao Wang on 12/17/21.
//

import Palico
import MathLib

// Log
Log.registerLogger(name: "Editor", level: .trace)

let app = Editor(name: "Palico Engine v1.0", arguments: CommandLine.arguments, size: Int2(1440, 810))
app.run()

Log.info("Exit(0)")

import Network

private let conditionMessage = """
\nArguments must have the following:
\nhostname, port number, minimum buffer size and maximum buffer size.
\nExample: swift main.swift ::1 4390 1 1024
"""

////////////////////////////////////////////////////////////////////////
/// Program must be started with the following arguments:
/// hostname, port, min buffer, max buffer.
/// eg: swift main.swift ::1 4390 1 1024
////////////////////////////////////////////////////////////////////////
guard CommandLine.arguments.count == 5 else {
    print(conditionMessage)
    exit(EXIT_FAILURE)
}

private let HOST: String = CommandLine.arguments[1]
private let PORT: String = CommandLine.arguments[2]
private let MINBUFFERSIZE: Int = Int(CommandLine.arguments[3])!
private let MAXBUFFERSIZE: Int = Int(CommandLine.arguments[4])!

private let host = NWEndpoint.Host(HOST)
private let port = NWEndpoint.Port(PORT)!
private let conn = NWConnection(host: host, port: port, using: .tcp)


////////////////////////////////////////////////////////////////////////
/// Sends a message to the socket connection.
/// - Parameter message: The message to send to the socket connection.
/// - Parameter connection: The socket connection.
////////////////////////////////////////////////////////////////////////
private func send(message: String, to connection: NWConnection) {
    connection.send(content: message.data(using: .utf8), completion: .contentProcessed({ error in
        error.flatMap { e in
            if let error = error {
                print(error)
            } else {
                print("Message sent!!!")
            }
        }
    }))
}

////////////////////////////////////////////////////////////////////////
/// Register a callback to receive messsages from the socket connection.
/// - Parameter connection: The socket connection.
////////////////////////////////////////////////////////////////////////
private func receive(connection: NWConnection) {
    connection.receive(minimumIncompleteLength: MINBUFFERSIZE, maximumLength: MAXBUFFERSIZE) { data, context, isComplete, error in
        data.flatMap { content in
            if let content = String(data: content, encoding: .utf8) {
                print(content, terminator:"")
            }
        }

        if case(.none) = error {
            receive(connection: connection)
        }
    }
}

////////////////////////////////////////////////////////////////////////
/// Monitors the state of socket connection.
/// - Note: The program exits upon an error on the waiting state, however
///         the advice is to wait for change of state of cancel the 
///         connection in case users chooses too (tap button, etc).
////////////////////////////////////////////////////////////////////////
conn.stateUpdateHandler = { state in
    switch state {
    case .ready:
        print("State = ready")
        receive(connection: conn)
    case .setup:
        print("State = setup")
    case .waiting(let error):
        print("State = waiting: \(error)")
        exit(EXIT_SUCCESS)
    case .preparing:
        print("State = preparing")
    case .failed(let error):
        print("State = failed: \(error)")
        exit(EXIT_FAILURE)
    case .cancelled:
        print("State = cancelled")
        exit(EXIT_SUCCESS)
    @unknown default:
        print("State = unknown")
        exit(EXIT_FAILURE)
    }
}

/// Here for debugging purposes.
conn.viabilityUpdateHandler = { visibility in
    print("Visibiliy = \(visibility)")
}

/// Here for debugging purposes.
conn.pathUpdateHandler = { path in
    print("Connection path = \(String(describing: conn.currentPath))")
    print("Path status: \(path.status)")
    print("Path local endpoint: \(String(describing: path.localEndpoint))")
    print("Path remote endpoint: \(String(describing: path.remoteEndpoint))")
    print("Path available interfaces count: \(path.availableInterfaces.count)")
    print("Path gateways count: \(path.gateways.count)")
}

/// Here for debugging purposes.
conn.betterPathUpdateHandler = { hasBetterPath in
    print(hasBetterPath)
}

////////////////////////////////////////////////////////////////////
/// Read to the STDIN in a background thread.
////////////////////////////////////////////////////////////////////
DispatchQueue.global().async {
    while let line = readLine() {
        send(message: line, to: conn)
    }
}

/// Start the connection in the main queue and dispatch
conn.start(queue: .main)
dispatchMain()

import CoreGraphics
import Darwin
import Foundation

setbuf(stdout, nil)

final class DisplayWatcher: @unchecked Sendable {
    private let queue = DispatchQueue(label: "wallpaper-calendar-display-watch")
    private let refreshScript: String
    private var pendingApply: DispatchWorkItem?

    init(refreshScript: String) {
        self.refreshScript = refreshScript
    }

    func scheduleApply() {
        queue.async { [self] in
            pendingApply?.cancel()

            let work = DispatchWorkItem { [refreshScript] in
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/bin/bash")
                process.arguments = [refreshScript, "--apply"]
                process.standardOutput = FileHandle.standardOutput
                process.standardError = FileHandle.standardError

                do {
                    try process.run()
                    process.waitUntilExit()
                    if process.terminationStatus != 0 {
                        fputs("wallpaper reapply exited \(process.terminationStatus)\n", stderr)
                    }
                } catch {
                    fputs("could not run wallpaper reapply: \(error)\n", stderr)
                }
            }

            pendingApply = work
            queue.asyncAfter(deadline: .now() + 2, execute: work)
        }
    }
}

func displayChanged(
    _ display: CGDirectDisplayID,
    _ flags: CGDisplayChangeSummaryFlags,
    _ context: UnsafeMutableRawPointer?
) {
    guard !flags.contains(.beginConfigurationFlag), let context else { return }
    Unmanaged<DisplayWatcher>.fromOpaque(context).takeUnretainedValue().scheduleApply()
}

guard CommandLine.arguments.count == 2 else {
    fputs("usage: watch-display-changes.swift REFRESH_SCRIPT\n", stderr)
    exit(64)
}

let watcher = DisplayWatcher(refreshScript: CommandLine.arguments[1])
let context = Unmanaged.passUnretained(watcher).toOpaque()

guard CGDisplayRegisterReconfigurationCallback(displayChanged, context) == .success else {
    fputs("could not register the display callback\n", stderr)
    exit(1)
}

var displayCount: UInt32 = 0
CGGetOnlineDisplayList(0, nil, &displayCount)
print("\(Date()) watching \(displayCount) displays")
RunLoop.main.run()

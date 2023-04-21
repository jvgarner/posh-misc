choco outdated --ignore-pinned
if ($LastExitCode -eq 2) {
    throw "Outdated Choco Packages Detected"
}
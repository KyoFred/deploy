$repoUrl = "https://github.com/Kyo-cera/knm-app"
$deployPath = "C:\projects\knm-app"
$branch = "developmen"
$logFile = "C:\projects\deploy\deploy.log"

function Log-Message {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$timestamp] $message"
}

try {
    if (Test-Path $deployPath) {
        Set-Location $deployPath
        git fetch origin
        $localCommit = git rev-parse HEAD
        $remoteCommit = git rev-parse origin/$branch
        if ($localCommit -eq $remoteCommit) {
            Log-Message "Nessuna modifica rilevata. Nessun deploy necessario."
            exit 0
        }
        git pull origin $branch
    } else {
        git clone $repoUrl $deployPath
        Set-Location $deployPath
    }

    Log-Message "Repository aggiornato con successo."

    # Install dependencies
    npm install
    Log-Message "Dipendenze installate con successo."

    # Build the project for production
    npm run build
    Log-Message "Build completata con successo."

    # Start the project
    npm start
    Log-Message "Applicazione avviata con successo."

} catch {
    Log-Message "ERRORE durante il deploy: $_"
    exit 1
}

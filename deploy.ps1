# Configurazione iniziale
$repoUrl = "https://github.com/KyoFred/Digital-platforn-app.git"
$deployPath = "C:\projects\Digital-platforn-app"
$branch = "master"
$logFile = "C:\projects\deploy\deploy.log"

# Funzione per logging
function Log-Message {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$timestamp] $message"
}

# Verifica modifiche al branch master
try {
    # Clona o aggiorna il repository
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

    # Esegui comandi di deploy (esempio per Node.js)
    # npm install
    # npm run build

    # Riavvia l'applicazione (esempio per servizi Windows)
    # Stop-Service "MyAppService"
    # Start-Service "MyAppService"
    # Log-Message "Applicazione riavviata."

} catch {
    Log-Message "ERRORE durante il deploy: $_"
    exit 1
}
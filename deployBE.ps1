# Configurazione iniziale
$repoUrl = "https://github.com/Kyo-cera/knm-api"
$deployPath = "C:\projects\knm-api"
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

} catch {
    Log-Message "ERRORE durante il deploy: $_"
    exit 1
}
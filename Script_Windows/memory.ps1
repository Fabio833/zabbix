# Função para obter a linha de comando de um processo usando WMI
function Get-ProcessCommandLine($ProcessId) {
    $commandLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $ProcessId").CommandLine
    return $commandLine
}

# Obtém todos os processos e os ordena pelo uso de memória RAM em ordem decrescente
$top5Processes = Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10

# Para cada processo, imprime os detalhes diretamente
$top5Processes | ForEach-Object {
    $processId = $_.Id
    $commandLine = Get-ProcessCommandLine -ProcessId $processId

    # Limita a CommandLine a 150 caracteres, se for mais longa
    if ($commandLine.Length -gt 150) {
        $commandLine = $commandLine.Substring(0, 120)
    }


	$output = "{0,-20} {1,11} {2} {3}" -f  $_.ProcessName, [math]::Round($_.WorkingSet / 1MB, 2) ,"    ", $commandLine
	
    # Imprime os detalhes do processo
    Write-Output $output
}
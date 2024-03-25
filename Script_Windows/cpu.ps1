$topProcesses = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10

foreach ($process in $topProcesses) {
    $commandLine = $null

    # Tenta obter o command line utilizando o id do processo em específico
    try {
        $commandLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($process.Id)").CommandLine
    } catch {
        $commandLine = "N/A"
    }

    # Limita a CommandLine a 150 caracteres, se for mais longa
    if ($commandLine.Length -gt 120) {
        $commandLine = $commandLine.Substring(0, 130)
    }

    # Limita o uso da CPU a duas casas decimais após a vírgula
    $cpuUsageFormatted = "{0:N2}" -f $process.CPU

    # Limita o tamanho do ProcessName
    $limitedProcessName = $process.ProcessName.Substring(0, [Math]::Min($process.ProcessName.Length, 10))

    # Formatando manualmente a saída
    $output = "{0,-15} {1,-10} {2,-10} {3}" -f $limitedProcessName, $cpuUsageFormatted, $process.Id, $commandLine
    Write-Output $output
}
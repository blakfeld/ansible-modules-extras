#!powershell
# Michael Perzel 1/22/2014
# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;

$result = New-Object PSObject -Property @{
    changed = $false
    success = $false
    output = ""
}

If ($params.src) {
    $src = $params.src
}
Else {
    Fail-Json (New-Object PSObject $fail) "missing required argument: src"
}

If ($params.dest) {
    $dest = $params.dest
}
Else {
    Fail-Json (New-Object PSObject $fail) "missing required argument: dest"
}

If ($params.include) {
    $include = $params.include
}
If ($params.exclude) {
    $exclude = $params.exclude
}

If ($params.creates) {
    $creates = $params.creates
}

If( $creates -and (Test-Path $dest/$creates)) {
    $result.output += "File already exists, not unzipping"
    $result.success = $true
    Exit-Json $result
}

If(!(Test-Path $src)) {
    Fail-Json (New-Object PSObject $fail) "$src file does not exist"
}

try {
    $psrc = $src
    if($include){
        $psrc = '{0}\{1}' -f $psrc, $include
    }

    $result.output += "Extract-ZipFile"
    $result.output += ("Extracting Zip File from {0} to {1}" -f $psrc, $dest)
    $shell_app = new-object -com shell.application
    $sourceFolder = $shell_app.namespace($src)
    $destFolder = $shell_app.namespace($dest)
    $items = $sourceFolder.Items()
    if($include){
        $items = $sourceFolder.Items() | ?{$_.Name -eq $include}
    }
    elseif($exclude){
        $items = $sourceFolder.Items() | ?{$_.Name -ne $exclude}
    }

    $items | ?{ $_.IsFolder } | %{ $destFolder.CopyHere($_.GetFolder, 16) }
    $items | ?{ !$_.IsFolder } | %{ $destFolder.CopyHere($_, 16) }

    $result.output += ('Extracting {0} complete.' -f $psrc)

    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell_app) | Out-Null
    $result.success = $true
    $result.changed = $true

}
catch {
    Fail-Json (New-Object PSObject $fail)  $_.Exception.Message
}

If ($result.success) {
    Exit-Json $result
}

function Test-Asn1 {
  param( [String] $file )

  If (-Not $file.EndsWith("asn1")) {
    Return 0
  }

  Write-Host ("Validating " + $file)
  $tempFile = New-TemporaryFile
  grun ASN_3gpp modules $file > $null 2>$tempFile
  $validationResult = Get-Content $tempFile
  If ($validationResult.Length -ne 0) {
    Write-Warning ("Validation failed: " + $file)
    Write-Host "$validationResult" -Separator "`n"
    Return 1
  }
  Return 0
}

$staged = git diff --name-only --cached
$measureInfo = $staged | Measure-Object -Line
$lines = $measureInfo.Lines
Write-Host ("$lines" + " staged file(s):")
Write-Host $staged -Separator "`n"

If ($lines -eq 1) {
  $file = $staged
  $result = Test-Asn1 -file $file
  Exit $result
} Else {
  For ($i = 0; $i -lt $lines; $i++) {
    $file = $staged[$i]
    $result = Test-Asn1 -file $file
    if ($result -ne 0) {
      Exit $result
    }
  }
}
Exit 0

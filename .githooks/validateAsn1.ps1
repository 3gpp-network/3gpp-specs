function Test-Asn1 {
  param( [String] $file )

  If (-Not $file.EndsWith("asn1")) {
    Return 0
  }

  Write-Host ("Validating " + $file)
  $validationResult = grun ASN_3gpp modules $file 2>&1
  If ($validationResult.Length -ne 0) {
    Write-Warning ("Validation failed: " + $file)
    Write-Warning "$validationResult"
    Return 1
  }
  Return 0
}

$staged = git diff --name-only --cached
$measureInfo = $staged | Measure-Object -Line
$lines = $measureInfo.Lines
Write-Host ("$lines" + " staged file(s):")
Write-Host $staged -Separator "`n"

If ($lines -eq 0) {
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

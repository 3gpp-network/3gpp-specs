Write-Host "Validate ASN.1 before commit"

$date = Get-Date -Format "yyyyddMM-HHmm"
$stashName = "pre-commit-" + $date
git stash save --keep-index $stashName

.\.githooks\validateAsn1.ps1
$validateResult = $?

git stash pop

If ($validateResult -eq $TRUE) {
  Exit 0
} Else {
  Exit 1
}

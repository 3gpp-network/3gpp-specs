STAGED=$(git diff --name-only --cached)
for file  in $STAGED; do
  grun ASN_3gpp modules $file
  if [[ $? == 0 ]]; then
    exit 1
  fi
done
exit 0

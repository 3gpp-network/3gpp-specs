STASH_NAME="pre-commit-$(date +%Y%m%d-%H%M)"
git stash save --keep-index $STASH_NAME

./test.sh
TEST_RESULT = $?

STASHES=$(git stash list)
if [[ $STASHES == "$STASH_NAME" ]]; then
  git stash pop -q
fi

[ $TEST_RESULT -ne 0 ] && exit 1
exit 0

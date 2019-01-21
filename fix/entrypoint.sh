#!/bin/sh
set -e

cd "${CS_FIXER_ACTION_WORKING_DIR:-.}"

WORKSPACE=${CS_FIXER_ACTION_WORKSPACE:-default}
echo $WORKSPACE

set +e
OUTPUT=$(sh -c "php-cs-fixer fix $WORKSPACE --config $WORKSPACE/.php_cs  --dry-run --diff $*" 2>&1)
SUCCESS=$?
echo "$OUTPUT"
set -e

if [ "$CS_FIXER_ACTION_WORKSPACE" = "1" ] || [ "$CS_FIXER_ACTION_WORKSPACE" = "false" ]; then
    exit $SUCCESS
fi

COMMENT=""

# If not successful, post failed plan output.
if [ $SUCCESS -ne 0 ]; then
    COMMENT="#### \`php-cs-fixer\` observing your code
\`\`\`
$OUTPUT
\`\`\`"
else
    FMT_PLAN=$(echo "$OUTPUT" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
    COMMENT="\`\`\`diff
$FMT_PLAN
\`\`\`"
fi


PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS

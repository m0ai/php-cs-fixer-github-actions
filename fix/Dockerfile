FROM herloct/php-cs-fixer:latest 

LABEL "com.github.actions.name"="php-cs-fixer fix"
LABEL "com.github.actions.description"="Run phpc-cs-fixer fix"
LABEL "com.github.actions.icon"="file"
LABEL "com.github.actions.color"="pink"

LABEL "repository"="https://github.com/m0ai/php-cs-fixer-github-actions.git"
LABEL "homepage"="https://github.com/m0ai/php-cs-fixer-github-actions.git"
LABEL "maintainer"="frozenmoai@gmail.com"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

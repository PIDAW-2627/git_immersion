#!/bin/bash
# Genera los labs dentro de un contenedor ruby:3.1.2 (ver README.md).
# Trabaja sobre una copia del proyecto y solo copia el HTML resultante
# a docs/, desde donde lo sirve GitHub Pages.
set -e

cp -r /src /app
cd /app
rm -rf auto samples git_tutorial/html git_tutorial/repos

git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
git config --global init.defaultBranch main
git config --global user.name "Git Immersion"
git config --global user.email "git-immersion@example.com"

bundle install --quiet
echo "Ejecutando los labs (rake run)..."
bundle exec rake run > /tmp/rake-run.log 2>&1 || { tail -30 /tmp/rake-run.log; exit 1; }
echo "Generando el HTML (rake labs)..."
bundle exec rake labs > /dev/null

rm -rf /src/docs
cp -r git_tutorial/html /src/docs
echo "Listo: docs/index.html"

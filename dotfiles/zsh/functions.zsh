organize() {
  docker run -it --rm -v $(pwd):$(pwd) -w $(pwd) jasonben/organize organize-rt --output="${2:-organized_rt}" --source="$1"
}

syncthing() {
  share="$HOME/Downloads/share"
  docker run --rm -d -p 8384:8384 -p 22000:22000 \
      -v $share:/var/syncthing/files \
      -v $share/syncthing:/var/syncthing \
      syncthing/syncthing:latest
  firefox "http://0.0.0.0:8384"
  echo "syncthing gui: 0.0.0.0:8384"
  echo "sharing $share/files"
}

dive () {
  if [[ -n "$DOCKER_HOST" ]]; then
    # inside the ide container: reach the docker-sock proxy over its network
    docker run --rm -it --network dockersock -e DOCKER_HOST="$DOCKER_HOST" \
        wagoodman/dive:latest "$1"
  else
    docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
        wagoodman/dive:latest "$1"
  fi
}

bs () {
  browser-sync start --proxy $1 --files "app/assets/stylesheets/**/*.scss, app/views/**/*.html.slim"
}

mkstylelint() {
  npm install --save-dev stylelint
  npm install --save-dev stylelint-order
  npm install --save-dev stylelint-scss
  npm install --save-dev stylelint-config-sass-guidelines
  echo '{"extends": "stylelint-config-sass-guidelines"}' > .stylelintrc.json
}

ipinfo() {
  curl -s "http://ipinfo.io/$1" | jq .
}

fqdninfo() {
  curl -s https://dns.google.com/resolve?name=$1 | jq .
  ip=$(curl -s https://dns.google.com/resolve?name=$1 | jq -r '.["Answer"][] | select(.type==1) | .["data"]')
  ipinfo $ip
}

whoport() {
  doas netstat -tlnp | grep ":$1 "
}

ctags_rails() {
  mkdir -p .ide && ctags -R -f .ide/ctags . $(bundle list --paths)
}

rm_rec() {
  find . -name "$1" -prune -exec rm -rf -- {} +
}

# db, table
table_to_csv() {
  psql -d $1 -c "COPY (SELECT * from $2) TO STDOUT with CSV HEADER" > $2.csv
}

docker-volumes() {
  docker ps -a --format '{{ .ID }}' | xargs -I {} docker inspect -f '{{ .Name }}{{ printf "\n" }}{{ range .Mounts }}{{ printf "\n\t" }}{{ .Type }} {{ if eq .Type "bind" }}{{ .Source }}{{ end }}{{ .Name }} => {{ .Destination }}{{ end }}{{ printf "\n" }}' {}
}

dc-logs() {
  docker compose logs -f --tail=500 $1
}

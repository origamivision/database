#!/usr/bin/env sh
set -eu

ENV_FILE=".env"
EXAMPLE_FILE=".env.example"

if [ -f "$ENV_FILE" ]; then
  echo "$ENV_FILE already exists. Leaving it unchanged."
  exit 0
fi

if [ ! -f "$EXAMPLE_FILE" ]; then
  echo "Missing $EXAMPLE_FILE" >&2
  exit 1
fi

gen_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 24
  else
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 48
  fi
}

ROOT_PW="$(gen_secret)"
APP_PW="$(gen_secret)"

cat > "$ENV_FILE" <<EOF2
MYSQL_ROOT_PASSWORD=$ROOT_PW
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=$APP_PW
MYSQL_PORT=3306
ADMINER_PORT=8080
EOF2

chmod 600 "$ENV_FILE"
echo "Created $ENV_FILE with generated credentials."

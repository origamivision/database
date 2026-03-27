# Database Container Stack

This folder runs a local MySQL + Adminer stack with Docker Compose.

## Services

- `mysql_db_container`: MySQL (pinned digest)
- `adminer_container`: Adminer (pinned digest)

Ports are bound to localhost only:

- MySQL: `127.0.0.1:${MYSQL_PORT}`
- Adminer: `http://127.0.0.1:${ADMINER_PORT}`

## Configuration

1. Copy the template (if needed):

```bash
cp .env.example .env
```

2. Edit `.env` values:

- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_PORT`
- `ADMINER_PORT`

## Common Commands

Start stack:

```bash
docker compose up -d
```

Stop stack:

```bash
docker compose down
```

Stop stack and remove data volume (destructive):

```bash
docker compose down -v
```

Restart stack:

```bash
docker compose up -d --force-recreate
```

View status:

```bash
docker compose ps
```

Tail MySQL logs:

```bash
docker compose logs -f mysql_db_container
```

## Health Check

MySQL has a built-in healthcheck. You can inspect health with:

```bash
docker inspect database-mysql_db_container-1 --format 'status={{.State.Status}} health={{if .State.Health}}{{.State.Health.Status}}{{else}}n/a{{end}}'
```

## Connect to MySQL

Root login (from host):

```bash
source .env
mysql -h 127.0.0.1 -P "$MYSQL_PORT" -u root -p"$MYSQL_ROOT_PASSWORD"
```

App user login (from host):

```bash
source .env
mysql -h 127.0.0.1 -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
```

Shell into container and run MySQL client:

```bash
docker exec -it database-mysql_db_container-1 mysql -u root -p
```

## Adminer Login

Open:

- `http://127.0.0.1:8080` (or your `ADMINER_PORT`)

Use:

- System: `MySQL`
- Server: `mysql_db_container`
- Username: `root` or `MYSQL_USER`
- Password: from `.env`
- Database: `MYSQL_DATABASE` (optional)

## Notes

- `.env` contains secrets and should stay out of version control.

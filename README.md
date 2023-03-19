# Automatic configuration of sqlalchemy with alembic

### flags

`-d`: database name (this flag is required) <br>
`-u`: username (default postgres) <br>
`-p`: password (default password) <br>
`-h`: hostname (default localhost) <br>

### example of usage

`./async_sa.sh -d test_db` <br>
<b>Creates a test_db database and configures alembic for it
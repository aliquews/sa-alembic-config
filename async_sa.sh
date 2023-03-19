#!/usr/bin/zsh

db_name=""
username="postgres"
password="password"
host="localhost"

while getopts "d:u:p:h:" opt; do
    case ${opt} in
        d) db_name="$OPTARG";;
        u) username="$OPTARG";;
        p) password="$OPTARG";;
        h) host="$OPTARG";;
        \?) echo "Usage: $0 [-d <database_name>] [-u <username>] [-p <password>] [-h <host>]"
            exit 1;;
    esac
done

if [ -z "$db_name" ]; then
    echo "Error: database name is required"
    echo "Usage: $0 [-d <database_name>] [-u <username>] [-p <password>] [-h <host>]"
    exit 1
fi

db_url="postgresql+asyncpg://$username:$password@$host/$db_name"
echo "DB_URL = '$db_url'" > config.py

sudo -iu postgres << EOF
createdb $db_name
exit
EOF


python -m venv .venv
. .venv/bin/activate

pip install --upgrade pip sqlalchemy alembic sqlalchemy_utils asyncpg

alembic init -t async alembic

sed -i '/^from alembic import context$/a from config import DB_URL\n\n# import your declarative_base here' alembic/env.py
sed -i "/^config = context.config$/a section = config.config_ini_section\n\nconfig.set_section_option(section, 'DB_URL', DB_URL)" alembic/env.py

sed -i 's/^sqlalchemy\.url.*/sqlalchemy.url = %(DB_URL)s/' alembic.ini


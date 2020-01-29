#! /bin/bash

# temporeraly import variables
export $(cat .env)

# run postgres and hasura in containers, wait 2 seconds to start postgres
docker-compose up -d
sleep 2

# init database with basic tables
docker exec -ti juno_postgres psql -f /root/schema/validator.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti juno_postgres psql -f /root/schema/pre_commit.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti juno_postgres psql -f /root/schema/block.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME
docker exec -ti juno_postgres psql -f /root/schema/transaction.sql -d $POSTGRES_DB_NAME -U $POSTGRES_USER_NAME

# create docker.config.toml, put values from .env file to config.toml
echo -n 'rpc_url="' >> docker.config.toml && echo -n $RPC_URL >> docker.config.toml && echo -n '"' >> docker.config.toml
sed -i "/rpc/a client_node=\"$CLIENT_URL\"" docker.config.toml
echo '[database]' >> docker.config.toml
sed -i "/database/a host=\"$POSTGRES_DB_HOST\"" docker.config.toml
sed -i "/host/a port=$POSTGRES_DB_PORT" docker.config.toml
sed -i "/port/a name=\"$POSTGRES_DB_NAME\"" docker.config.toml
sed -i "/name/a user=\"$POSTGRES_USER_NAME\"" docker.config.toml
sed -i "/user/a password=\"$POSTGRES_DB_PASSWORD\"" docker.config.toml
sed -i "/password/a ssl_mode=\"$JUNO_SSL_MODE\"" docker.config.toml

# build juno and run it in container
docker build -t juno:latest --build-arg JUNO_WORKERS_NUMBER=$JUNO_WORKERS_NUMBER .
docker run -d --name juno --network="host" juno:latest

# remove config toml, as far as it copyed to container
rm docker.config.toml

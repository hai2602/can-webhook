#!/bin/bash
trap 'kill 1' SIGTERM SIGINT

cd /can-webhook
cp /file.env /can-webhook/.env 

# Check ENV Values
echo $AWS_REGION
echo $DYNAMODB_BADGE_TABLE
echo $DYNAMODB_TABLE_NAME
echo $POSTGRESQL_DB_HOST
echo $HISTORY_CANCHAIN_API_ENDPOINT
echo $PROJECT_PREFIX

# Edit .env Variable Values
REDIS_CACHE_HOST=$(host redis.cache.${PROJECT_PREFIX} | cut -d' ' -f4 | head -1)
sed -i "s/##PROJECT_PREFIX##/$PROJECT_PREFIX/g" .env 
sed -i "s/##AWS_REGION##/$AWS_REGION/g" .env 
sed -i "s/##POSTGRESQL_DB_HOST##/$POSTGRESQL_DB_HOST/g" .env 
sed -i "s/##HISTORY_CANCHAIN_API_ENDPOINT##/$HISTORY_CANCHAIN_API_ENDPOINT/g" .env 
sed -i "s/##DYNAMODB_BADGE_TABLE##/$DYNAMODB_BADGE_TABLE/g" .env 
sed -i "s/##DYNAMODB_TABLE_NAME##/$DYNAMODB_TABLE_NAME/g" .env 
sed -i "s/##REDIS_CACHE_HOST##/$REDIS_CACHE_HOST/g" .env  # Because This ENV only reads IP Address
cat ".env" 

yarn start:production
# Keep the container running
sleep 5
exec pm2 logs

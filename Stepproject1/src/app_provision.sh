#!/bin/bash

# Wait until DB is ready
until nc -z 192.168.56.10 3306; do
  echo "Waiting for database to be reachable on 192.168.56.10:3306..."
  sleep 5
done

useradd -m -s /bin/bash $APP_USER

apt-get update
apt-get install -y openjdk-11-jdk git curl unzip

su - $APP_USER <<EOF
git clone https://${GIT_USER}:${GIT_TOKEN}@${GIT_REPO#https://} repo
cd repo/spring-petclinic
chmod +x mvnw
./mvnw package -DskipTests
mkdir -p $APP_DIR
chown -R $APP_USER:$APP_USER $APP_DIR
cp target/*.jar $APP_DIR/petclinic.jar

nohup java -jar $APP_DIR/petclinic.jar \
  --spring.profiles.active=mysql \
  --spring.datasource.url=jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME} \
  --spring.datasource.username=${DB_USER} \
  --spring.datasource.password=${DB_PASS} \
  > $APP_DIR/petclinic.log 2>&1 &
EOF

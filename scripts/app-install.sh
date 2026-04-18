#!/bin/bash
set -e
echo "=== START SETUP ==="

# Install packages
sudo yum update -y
sudo yum install -y docker aws-cli jq

sudo systemctl start docker
sudo systemctl enable docker

# -------------------------------
# 1. Generate APP_KEY + JWT_SECRET
# -------------------------------
echo "=== GENERATING KEYS ==="

KEYS=$(docker run --rm composer:latest php -r \
"echo json_encode([
  'app_key' => 'base64:' . base64_encode(random_bytes(32)),
  'jwt_secret' => bin2hex(random_bytes(32))
]);")

APP_KEY=$(echo $KEYS | jq -r '.app_key')
JWT_SECRET=$(echo $KEYS | jq -r '.jwt_secret')

# -------------------------------
# 2. Get DB secret from AWS
# -------------------------------
echo "=== FETCHING DB SECRET ==="

export AWS_DEFAULT_REGION=${aws_region}

SECRET=$(aws secretsmanager get-secret-value \
  --region ${aws_region} \
  --secret-id "${secret_arn}" \
  --query SecretString \
  --output text)

DB_USER=$(echo $SECRET | jq -r '.username')
DB_PASSWORD=$(echo $SECRET | jq -r '.password')

DB_NAME="${db_name}"
DB_HOST="${db_host}"

# -------------------------------
# 3. Create .env file
# -------------------------------
echo "=== CREATING ENV FILE ==="

cat <<EOF > /home/ec2-user/app.env
APP_NAME=Laravel
APP_ENV=production
APP_KEY=$APP_KEY
JWT_SECRET=$JWT_SECRET

DB_CONNECTION=mysql
DB_HOST=$DB_HOST
DB_PORT=3306
DB_DATABASE=$DB_NAME
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASSWORD

SESSION_DRIVER=database
CACHE_DRIVER=database
EOF

chmod 600 /home/ec2-user/app.env

# -------------------------------
# 4. Run application container
# -------------------------------
echo "=== STARTING APP ==="

sudo docker run -d \
  -p 8000:8000 \
  --name boardgame \
  --restart always \
  haycuulaytoi/api-htxh

sudo docker cp /home/ec2-user/app.env boardgame:/var/www/.env
sudo docker exec -u root boardgame chmod 644 /var/www/.env
sudo docker exec -u root boardgame chown www-data:www-data /var/www/.env
sudo docker restart boardgame


# -------------------------------
# 5. Wait for container ready
# -------------------------------
echo "=== WAITING FOR CONTAINER ==="

until sudo docker exec boardgame php artisan --version >/dev/null 2>&1; do
  echo "Waiting for container..."
  sleep 5
done

# -------------------------------
# 6. Run migrations + seed (AUTO)
# -------------------------------
# echo "=== RUNNING MIGRATIONS ==="

# sudo docker exec boardgame php artisan config:clear
# sudo docker exec boardgame php artisan migrate --force
# sudo docker exec boardgame php artisan db:seed --class=ConfigsTableSeeder --force
# sudo docker exec boardgame php artisan db:seed --class=UsersTableSeeder --force

# echo "=== DONE ==="
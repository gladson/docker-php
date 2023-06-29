docker_build_dev:
	docker-compose -f ./docker-compose-dev.yml up -d --build front_npm
	docker-compose -f ./docker-compose-dev.yml up -d --build backend_mailtest
	docker-compose -f ./docker-compose-dev.yml up -d --build backend_database
	docker-compose -f ./docker-compose-dev.yml up -d --build backend_artisan
	docker-compose -f ./docker-compose-dev.yml up -d --build backend_composer
	docker-compose -f ./docker-compose-dev.yml up -d --build backend_api
	docker-compose -f ./docker-compose-dev.yml up -d --build backend_php

docker_create_backend_dev: 
	rm -rf src/backend/{*,.*}
	# mkdir src/backend
	docker-compose -f ./docker-compose-dev.yml run --rm backend_composer create-project --prefer-dist --no-scripts laravel/laravel .
	docker-compose -f ./docker-compose-dev.yml run --rm backend_php chown -R laravel:laravel /var/www/html/bootstrap/ 
	docker-compose -f ./docker-compose-dev.yml run --rm backend_php chown -R laravel:laravel /var/www/html/storage/
	docker-compose -f ./docker-compose-dev.yml run --rm backend_composer install
	# sudo chown -R laravel:laravel src/backend/

docker_run_migrate_dev: 
	docker-compose -f ./docker-compose-dev.yml run --rm backend_artisan migrate

docker_run_start_dev: 
	docker compose --file 'docker-compose-dev.yml' --project-name 'base' start 

docker_run_create_front_dev:
	docker-compose -f ./docker-compose-dev.yml run --rm front_npm npm init vue@latest .

docker_run_install_front_dev:
	docker-compose -f ./docker-compose-dev.yml run --rm front_npm npm install

docker_run_start_front_dev:
	docker-compose -f ./docker-compose-dev.yml run --rm front_npm npm run dev -- --host

docker_rm_dev:
	docker-compose -f ./docker-compose-dev.yml -p base_app_dev down 
	docker image rm base_backend_php:latest
	docker image rm base_backend_api:latest
	docker image rm base_backend_artisan:latest
	docker image rm base_backend_composer:latest 
	docker image rm postgres:15-alpine
	docker image rm nginx:stable-alpine
	docker image rm node:current-alpine
	docker image rm postgres:15-alpine
	docker image rm php:7.3.33-fpm-alpine3.14


docker_clear_dev:
	docker-compose -f .\docker-compose-dev.yml run --rm backend_artisan route:clear
	docker-compose -f .\docker-compose-dev.yml run --rm backend_artisan config:clear
	docker-compose -f .\docker-compose-dev.yml run --rm backend_artisan cache:clear

docker_run_migrate_dev:
	docker-compose -f .\docker-compose-dev.yml run --rm backend_artisan migrate

docker_serve_dev:
	docker-compose -f .\docker-compose-dev.yml run --rm backend_artisan serve --host=0.0.0.0 --port=9000

docker_remove:
	docker-compose -f ./docker-compose-prod.yml -p 'base' down

# ================================== PRODUCTION ==================================

docker_build_prod:
	docker-compose -f ./docker-compose-prod.yml up -d --build front_npm
	docker-compose -f ./docker-compose-prod.yml up -d --build backend_database
	docker-compose -f ./docker-compose-prod.yml up -d --build backend_artisan
	docker-compose -f ./docker-compose-prod.yml up -d --build backend_api
	docker-compose -f ./docker-compose-prod.yml up -d --build backend_php

docker_run_migrate_prod: 
	docker-compose -f ./docker-compose-prod.yml run --rm backend_artisan migrate

docker_run_start_prod: 
	docker compose --file 'docker-compose-prod.yml' --project-name 'base' start 

docker_rm_prod:
	docker compose --file 'docker-compose-prod.yml' --project-name 'base' down 
	docker image rm base_backend_php:latest
	docker image rm base_backend_api:latest
	docker image rm base_backend_artisan:latest
	docker image rm nginx:stable-alpine
	docker image rm node:current-alpine
	docker image rm postgres:15-alpine
	docker image rm php:7.3.33-fpm-alpine3.14

# ================================== EXTRA ==================================

docker_install:
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh --dry-run
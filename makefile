upDev:
	USER=$$USER USER_ID=$$(id -u) GROUP_ID=$$(id -g) docker-compose -f docker-compose.dev.yml up --build --remove-orphans   -V   -d
stopDev:
	docker-compose -f docker-compose.dev.yml stop
composerInstall:
	docker exec -ti POC_SYMFONY_PHP composer install
	
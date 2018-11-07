# Lobsters in a Docker container

This repo is designed to automatically build an image of [Lobsters](https://github.com/lobsters/lobsters) to use it in a production environmment on Docker.

## Environment variables

### Database
+ `-e DB_HOST` Defaults to "lobsters-db". This should be the name of the mysql container.
+ `-e DB_PASSWORD` Defaults to "password". Required. This is the password of the database to use.
+ `-e DB_USER` Defaults to "root". This is the name of the database user to use.
+ `-e DB_DATABASE` Defaults to "lobsters". This is the name of the database to use.

### Application
+ `-e APP_DOMAIN` Defaults to "example.com". This should be your domain name.
+ `-e APP_NAME` Defaults to "Example News". This should be your application name.
+ `-e SECRET_KEY_BASE` Defaults to "". If empty a generic key will be generated.
+ `-e X_SENDFILE_HEADER` Defaults to "". [Specifies the header that your server uses for sending files](https://guides.rubyonrails.org/asset_pipeline.html#x-sendfile-headers).
+ `-e RAILS_SERVE_STATIC_FILES` Defaults to undefined. If present then Puma will serve static asset.

### Email
+ `-e SMTP_HOST` Defaults to "127.0.0.1".
+ `-e SMTP_PORT` Defaults to "25".
+ `-e SMTP_STARTTLS_AUTO` Defaults to "true".
+ `-e SMTP_USERNAME` Defaults to "".
+ `-e SMTP_PASSWORD` Defaults to "".

## Starting the containers

Change or add the environmment variables to suit your needs :

```bash
# Starting the mysql container
$ docker run --name lobsters-db -v /my/own/datadir:/var/lib/mysql -e "MYSQL_ROOT_PASSWORD=password" -e "MYSQL_DATABASE=lobsters" -d mysql:5.7

# Starting the lobsters container
$ docker run --name lobsters --link lobsters-db -e "RAILS_SERVE_STATIC_FILES=true" -p 3000:3000 -d guillaumebriday/lobsters-docker
```

## Docker compose

You can use this docker compose for this project. Create a `docker-compose.yml` file :

```yml
version: '3.1'

services:
  lobsters-db:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=lobsters
    volumes:
      - ./my/own/datadir:/var/lib/mysql

  lobsters:
    image: guillaumebriday/lobsters-docker
    environment:
      - RAILS_SERVE_STATIC_FILES=true
    ports:
      - "3000:3000"
    depends_on:
      - lobsters-db
```

And then run :

```bash
$ docker-compose up -d
```

## Reverse proxy

You can use [Traefik](https://traefik.io/) or [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) to access your application on custom domain.

In this case, remove the ports binding in the `docker-compose.yml` or in the `docker run` command.

## Administration

In lobsters, as mentioned in the documentation:

> Basic moderation happens on-site, but most other administrative tasks require use of the rails console in production.

To open a console in production:

```bash
$ docker run --rm -i --link lobsters-db guillaumebriday/lobsters-docker

# Or with docker-compose

$ docker-compose run --rm lobsters rails c
```

## Credits

Inspired by:

+ [https://github.com/jamesbrink/docker-lobsters](https://github.com/jamesbrink/docker-lobsters)

## Contributing

Do not hesitate to contribute to the project by adapting or adding features ! Bug reports or pull requests are welcome.

## License

This project is released under the [MIT](http://opensource.org/licenses/MIT) license.

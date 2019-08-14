[![Docker build status](https://img.shields.io/docker/build/guillaumebriday/lobsters-docker.svg)](https://hub.docker.com/r/guillaumebriday/lobsters-docker/)
[![Docker Pulls](https://img.shields.io/docker/pulls/guillaumebriday/lobsters-docker.svg)](https://hub.docker.com/r/guillaumebriday/lobsters-docker/)
[![Docker Stars](https://img.shields.io/docker/stars/guillaumebriday/lobsters-docker.svg)](https://hub.docker.com/r/guillaumebriday/lobsters-docker/)

# Lobsters in a Docker container

This repo is designed to automatically build an image of [Lobsters](https://github.com/lobsters/lobsters) to use it in a production environmment on Docker.

## Environment variables

### Database
+ `-e DATABASE_URL` Defaults to "`mysql2://root:password@lobsters-db/lobsters`".

Where `mysql2` is the adapter, `root` is the username, `password` is the password, `lobsters-db` is the host, and `lobsters` the name of database.

In this example, `lobsters-db` should be the name of the mysql container.

More informations: [https://edgeguides.rubyonrails.org/configuring.html#configuring-a-database](https://edgeguides.rubyonrails.org/configuring.html#configuring-a-database)

### Application
+ `-e APP_DOMAIN` Defaults to "example.com". This should be your domain name.
+ `-e APP_NAME` Defaults to "Example News". This should be your application name.
+ `-e SECRET_KEY_BASE` Defaults to "". If empty a generic key will be generated.
+ `-e X_SENDFILE_HEADER` Defaults to "". [Specifies the header that your server uses for sending files](https://guides.rubyonrails.org/asset_pipeline.html#x-sendfile-headers).
+ `-e RAILS_SERVE_STATIC_FILES` Defaults to "true". If present then Puma will serve static asset.

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

You can use this docker compose for this project:

```bash
$ docker-compose up -d
```

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

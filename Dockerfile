FROM ruby:2.3-slim
LABEL maintainer="guillaumebriday@gmail.com"

# Set our working directory.
WORKDIR /lobsters

# Setting env up
ENV RAILS_ENV="production" \
    RACK_ENV="production" \
    RAILS_SERVE_STATIC_FILES="true" \
    DATABASE_URL="mysql2://root:password@lobsters-db/lobsters" \
    APP_DOMAIN="example.com" \
    APP_NAME="Example News" \
    SECRET_KEY_BASE="" \
    X_SENDFILE_HEADER="" \
    SMTP_HOST="127.0.0.1" \
    SMTP_PORT="25" \
    SMTP_STARTTLS_AUTO="true" \
    SMTP_USERNAME="" \
    SMTP_PASSWORD=""

# Installing dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    apt-transport-https \
    mysql-client \
    default-libmysqlclient-dev \
    git \
    curl \
    bash \
    nodejs \
    gnupg

# Installing Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Cloning the project
RUN git init
RUN git remote add origin https://github.com/lobsters/lobsters.git
RUN git pull origin master --depth=1

# Copy the config in the container
COPY ./config /lobsters/config
COPY ./public/ /lobsters/public
COPY docker-entrypoint.sh /usr/local/bin/

RUN gem install bundler
RUN bundle install --without development test
RUN bundle add puma
RUN bundle exec rake assets:precompile

# Expose HTTP port
EXPOSE 3000

# Execute our entry script.
CMD ["docker-entrypoint.sh"]

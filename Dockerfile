FROM ruby:3.2

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends git nodejs npm \
    && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

EXPOSE 4000 35729

CMD ["bash", "-lc", "git config --global --add safe.directory '*' && sed -i 's/\\r$//' tools/init && bundle install && bash tools/init && bundle exec jekyll serve --host 0.0.0.0 --watch --force_polling --livereload"]

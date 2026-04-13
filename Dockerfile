FROM jekyll/jekyll:pages

WORKDIR /srv/jekyll

RUN apk add --no-cache build-base git

COPY Gemfile /srv/jekyll/Gemfile
RUN bundle install

COPY . /srv/jekyll

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]

EXPOSE 4000 35729

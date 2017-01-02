FROM ruby:2.3.0
COPY config/sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -qq -y --force-yes build-essential nodejs libpq-dev postgresql-client-9.4 libicu-dev --fix-missing --no-install-recommends
RUN apt-get clean

COPY bin/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

RUN useradd deploy -m
RUN usermod -u 1000 deploy
RUN groupmod -g 1000 deploy
# RUN chown deploy:deploy -R /home/deploy

USER deploy
RUN mkdir -p /home/deploy/app
WORKDIR /home/deploy/app
RUN echo "gem: --no-idoc --no-document --no-ri" > /home/deploy/.gemrc
RUN gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/

EXPOSE 3000
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["start"]

FROM ruby:2.3-jessie

ENV BUNDLE_PATH=/bundle

# Run security updates
RUN apt-get update && apt-get upgrade -y

# Install PostgreSQL client
RUN echo "deb http://apt.postgresql.org/pub/repos/apt jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-client-9.5

# Install Geo libraries
RUN apt-get install -y libgeos-dev libproj-dev gdal-bin

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
   apt-get install -y nodejs

# Install Bundler
RUN gem install bundler -v 1.17.3

# Install Chrome
RUN curl --silent --show-error --location --fail --retry 3 --output /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)  \
    && rm -rf /tmp/google-chrome-stable_current_amd64.deb \
    && sed -i 's|HERE/chrome"|HERE/chrome" --disable-setuid-sandbox --no-sandbox|g' \
        "/opt/google/chrome/google-chrome" \
    && google-chrome --version

# Install Chromedriver
RUN CHROME_VERSION="$(google-chrome --version)" \
    && export CHROMEDRIVER_RELEASE="$(echo $CHROME_VERSION | sed 's/^Google Chrome //')" && export CHROMEDRIVER_RELEASE=${CHROMEDRIVER_RELEASE%%.*} \
    && CHROMEDRIVER_VERSION=$(curl --silent --show-error --location --fail --retry 4 --retry-delay 5 http://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_RELEASE}) \
    && curl --silent --show-error --location --fail --retry 4 --retry-delay 5 --output /tmp/chromedriver_linux64.zip "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" \
    && cd /tmp \
    && unzip chromedriver_linux64.zip \
    && rm -rf chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && chromedriver --version

# Install PhantomJS
RUN PHANTOM_JS_VERSION="2.1.1" \
    && export PHANTOM_JS="phantomjs-${PHANTOM_JS_VERSION}-linux-x86_64" \
    && wget -q https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 \
    && tar xvjf $PHANTOM_JS.tar.bz2 \
    && mkdir -p /root/.phantomjs/${PHANTOM_JS_VERSION} \
    && mv $PHANTOM_JS /root/.phantomjs/${PHANTOM_JS_VERSION}/x86_64-linux

WORKDIR /app

CMD ["/bin/sh"]

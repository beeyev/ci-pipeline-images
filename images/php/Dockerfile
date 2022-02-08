ARG BASE_IMAGE=latest
FROM php:${BASE_IMAGE}

LABEL maintainer="https://github.com/beeyev"

ENV TERM="xterm-256color"
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH ${PATH}:/root/.composer/vendor/bin:/var/www/html/vendor/bin

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN set -eux \
    # Package Installation process
    && apt-get update && apt-get install --no-install-recommends -yq \
        git \
        nano \
        wget \
        zip \
        tar \
        gzip \
        bzip2 \
        unzip \
        ca-certificates \
        openssh-client \
        python3 \
        # `gnupg` is a dependency for `phive`
        gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux \
    && cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" \
    && sed -i "s|;*memory_limit =.*|memory_limit = -1|i" "${PHP_INI_DIR}/php.ini"

# Easy installation of PHP extensions in official PHP Docker images
# https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN set -eux && chmod +x /usr/local/bin/install-php-extensions \
    &&  install-php-extensions \
        @composer-2 \
        ast-stable

RUN set -eux \
    # Symfony-cli install
    && wget --no-check-certificate -q -O /tmp/symfony-cli.deb $(wget --no-check-certificate -q -qO- https://api.github.com/repos/symfony-cli/symfony-cli/releases/latest | grep browser_download_url | grep amd64.deb  -m 1 | cut -d '"' -f 4) \
    && dpkg -i /tmp/symfony-cli.deb && symfony -V > /dev/null 2>&1 \
    # Taskfile (task) | https://taskfile.dev
    && sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin && task --help > /dev/null 2>&1

RUN set -eux && \
    #
    # phive | https://github.com/phar-io/phive
    wget --no-check-certificate -q https://phar.io/releases/phive.phar -O /usr/local/bin/phive && \
    chmod +x /usr/local/bin/phive && phive --help > /dev/null 2>&1 && \
    #
    # PHP Code Sniffer | https://github.com/squizlabs/PHP_CodeSniffer
    wget --no-check-certificate -q https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar -O /usr/local/bin/phpcs && \
    wget --no-check-certificate -q https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar -O /usr/local/bin/phpcbf && \
    chmod +x /usr/local/bin/phpcs && phpcs --help > /dev/null 2>&1 && \
    chmod +x /usr/local/bin/phpcbf && phpcbf --help > /dev/null 2>&1 && \
    #
    # PHP Copy/Paste Detector (PHPCPD) | https://github.com/sebastianbergmann/phpcpd
    wget --no-check-certificate -q https://phar.phpunit.de/phpcpd.phar -O /usr/local/bin/phpcpd && \
    chmod +x /usr/local/bin/phpcpd && phpcpd -v > /dev/null 2>&1 && \
    #
    # PhpMetrics | https://github.com/phpmetrics/PhpMetrics
    wget --no-check-certificate -q https://github.com/phpmetrics/PhpMetrics/releases/latest/download/phpmetrics.phar -O /usr/local/bin/phpmetrics && \
    chmod +x /usr/local/bin/phpmetrics && phpmetrics --version > /dev/null 2>&1 && \
    #
    # PHP Parallel Lint | https://github.com/php-parallel-lint/PHP-Parallel-Lint \
    wget --no-check-certificate -q https://github.com/php-parallel-lint/PHP-Parallel-Lint/releases/latest/download/parallel-lint.phar -O /usr/local/bin/parallel-lint && \
    chmod +x /usr/local/bin/parallel-lint && parallel-lint -V > /dev/null 2>&1 && \
    #
    # churn-php | https://github.com/bmitch/churn-php \
    wget --no-check-certificate -q https://github.com/bmitch/churn-php/releases/latest/download/churn.phar -O /usr/local/bin/churn && \
    chmod +x /usr/local/bin/churn && churn -V > /dev/null 2>&1 && \
    #
    # Fink | https://github.com/dantleech/fink
    wget --no-check-certificate -q https://github.com/dantleech/fink/releases/latest/download/fink.phar -O /usr/local/bin/fink && \
    chmod +x /usr/local/bin/fink && fink -V > /dev/null 2>&1 && \
    #
    # PHPMD | https://github.com/phpmd/phpmd
    wget --no-check-certificate -q https://github.com/phpmd/phpmd/releases/latest/download/phpmd.phar -O /usr/local/bin/phpmd && \
    chmod +x /usr/local/bin/phpmd && \
    #
    # composer-normalize | https://github.com/ergebnis/composer-normalize
    wget --no-check-certificate -q https://github.com/ergebnis/composer-normalize/releases/latest/download/composer-normalize.phar -O /usr/local/bin/composer-normalize && \
    chmod +x /usr/local/bin/composer-normalize && composer-normalize -V > /dev/null 2>&1 && \
    #
    # Deptrac | https://github.com/qossmic/deptrac
    wget --no-check-certificate -q https://github.com/qossmic/deptrac/releases/latest/download/deptrac.phar -O /usr/local/bin/deptrac && \
    chmod +x /usr/local/bin/deptrac && deptrac -V > /dev/null 2>&1 && \
    #
    # composer-unused | https://github.com/composer-unused/composer-unused
    wget --no-check-certificate -q https://github.com/composer-unused/composer-unused/releases/latest/download/composer-unused.phar -O /usr/local/bin/composer-unused && \
    chmod +x /usr/local/bin/composer-unused && composer-unused -V > /dev/null 2>&1 && \
    #
    # PHPStan - PHP Static Analysis Tool | https://github.com/phpstan/phpstan
    wget --no-check-certificate -q https://github.com/phpstan/phpstan/releases/latest/download/phpstan.phar -O /usr/local/bin/phpstan && \
    chmod +x /usr/local/bin/phpstan && phpstan -V > /dev/null 2>&1 && \
    #
    # Local PHP Security Checker | https://github.com/fabpot/local-php-security-checker
    wget --no-check-certificate  -q -O /usr/local/bin/local-php-security-checker $(wget --no-check-certificate -qO- https://api.github.com/repos/fabpot/local-php-security-checker/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4) && \
    chmod +x /usr/local/bin/local-php-security-checker && local-php-security-checker -help > /dev/null 2>&1 && \
    #
    # PHPLOC | https://github.com/sebastianbergmann/phploc
    wget --no-check-certificate -q https://phar.phpunit.de/phploc.phar -O /usr/local/bin/phploc && \
    chmod +x /usr/local/bin/phploc && phploc --help > /dev/null 2>&1 && \
    #
    # dephpend | https://github.com/mihaeu/dephpend
    wget --no-check-certificate  -q -O /usr/local/bin/dephpend $(wget --no-check-certificate -qO- https://api.github.com/repos/mihaeu/dephpend/releases/latest | grep browser_download_url | grep .phar -m 1 | cut -d '"' -f 4) && \
    chmod +x /usr/local/bin/dephpend && dephpend -V > /dev/null 2>&1 && \
    #
    # PHP Coding Standards Fixer (PHP-CS-Fixer) | https://github.com/FriendsOfPHP/PHP-CS-Fixer
    wget --no-check-certificate -q https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/latest/download/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer && \
    chmod +x /usr/local/bin/php-cs-fixer && php-cs-fixer -V > /dev/null 2>&1 && \
    #
    # Phan | https://github.com/phan/phan
    wget --no-check-certificate -q https://github.com/phan/phan/releases/latest/download/phan.phar -O /usr/local/bin/phan && \
    chmod +x /usr/local/bin/phan && phan -v > /dev/null 2>&1 && \
    #
    # phpDocumentor | https://www.phpdoc.org/
    wget --no-check-certificate -q https://phpdoc.org/phpDocumentor.phar -O /usr/local/bin/phpDocumentor && \
    chmod +x /usr/local/bin/phpDocumentor && phpDocumentor -V > /dev/null 2>&1 && \
    #
    # Psalm | https://github.com/vimeo/psalm
    wget --no-check-certificate -q https://github.com/vimeo/psalm/releases/latest/download/psalm.phar -O /usr/local/bin/psalm && \
    chmod +x /usr/local/bin/psalm && psalm -v > /dev/null 2>&1 && \
    #
    # yaml-lint | https://github.com/j13k/yaml-lint
    wget --no-check-certificate -q https://github.com/j13k/yaml-lint/releases/latest/download/yaml-lint.phar -O /usr/local/bin/yaml-lint && \
    chmod +x /usr/local/bin/yaml-lint && yaml-lint -V > /dev/null 2>&1 && \
    #
    # ComposerRequireChecker | https://github.com/maglnet/ComposerRequireChecker
    if [ `echo ${PHP_VERSION} | cut -c1-3` = "7.4" ]; then \
        wget --no-check-certificate -q https://github.com/maglnet/ComposerRequireChecker/releases/download/3.8.0/composer-require-checker.phar -O /usr/local/bin/composer-require-checker \
    ; else \
        wget --no-check-certificate -q https://github.com/maglnet/ComposerRequireChecker/releases/latest/download/composer-require-checker.phar -O /usr/local/bin/composer-require-checker \
    ; fi && \
    chmod +x /usr/local/bin/composer-require-checker && composer-require-checker -V > /dev/null 2>&1 \

RUN set -eux \
    && composer global require \
        --no-progress --optimize-autoloader --no-interaction --no-ansi --no-scripts \
        #
        # PHP VarDump Check (var-dump-check) | https://github.com/php-parallel-lint/PHP-Var-Dump-Check
        php-parallel-lint/php-var-dump-check \
        #
        # PHP Magic Number Detector (PHPMND) | https://github.com/povils/phpmnd
        povils/phpmnd \
        #
        # PHP Depend | https://github.com/pdepend/pdepend
        pdepend/pdepend \
        #
        # PHP Insights | https://github.com/nunomaduro/phpinsights
        nunomaduro/phpinsights \
        #
        # PhpDeprecationDetector (phpdd) | https://github.com/wapmorgan/PhpDeprecationDetector
        wapmorgan/php-deprecation-detector \
        #
        # PHPLint | https://github.com/overtrue/phplint \
        overtrue/phplint \
        #
        # Rector | https://github.com/rectorphp/rector \
        rector/rector \
    # test composer executables
    && var-dump-check -V > /dev/null 2>&1 && phpmnd -V > /dev/null 2>&1 && phpinsights -V > /dev/null 2>&1 && phpdd -V > /dev/null 2>&1 && phplint -V > /dev/null 2>&1 && rector -V > /dev/null 2>&1

COPY  ./etc/hello-msg.sh /etc/hello-msg.sh
COPY  ./etc/.bashrc /root/.bashrc
RUN set -eux && \
    chmod +x /etc/hello-msg.sh

ARG MAINTAINER="https://github.com/beeyev"
ENV CONTAINER_COPYRIGHT=${MAINTAINER}
#Command bellow will be executed in motd via eval function, example: eval ${CONTAINER_HELLO_TEXT}
ENV CONTAINER_HELLO_TEXT="printf \"PHP Version: \${cGreen}\${PHP_VERSION}\${cNo}\n\""
#These params meant to be set by CI
ARG BUILD_DATE
ENV BUILD_DATE=${BUILD_DATE}
ARG BUILD_INFO
ENV BUILD_INFO=${BUILD_INFO}

WORKDIR /var/www/html

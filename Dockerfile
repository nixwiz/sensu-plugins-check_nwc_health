FROM nixwiz29/sensu-perl-runtime-5.30.1-alpine3.8:latest

ARG PLUGIN_VERSION=7.10.1.5
ARG ASSET_VERSION=local_build

RUN curl -s -O -L https://labs.consol.de/assets/downloads/nagios/check_nwc_health-${PLUGIN_VERSION}.tar.gz && \
  tar xzf check_nwc_health-${PLUGIN_VERSION}.tar.gz && \
  cd check_nwc_health-${PLUGIN_VERSION} && \
  PATH=/opt/perl/bin:${PATH} ./configure --with-nagios-user=sensu --with-nagios-group=sensu && \
  make && \
  test -x plugins-scripts/check_nwc_health && \
  sed -i -e '1s,^.*$,#!/usr/bin/env perl,' plugins-scripts/check_nwc_health && \
  mkdir -p dist/bin && \
  cp plugins-scripts/check_nwc_health dist/bin && \
  cp AUTHORS ChangeLog COPYING README THANKS TODO dist/

RUN test -d /assets && \
  export SENSU_ASSET="/assets/sensu-plugins-check_nwc_health_${ASSET_VERSION}.tar.gz" && \
  cd check_nwc_health-${PLUGIN_VERSION} && \
  tar -czf $SENSU_ASSET -C dist/ .


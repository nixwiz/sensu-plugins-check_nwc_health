
[![Bonsai Asset Badge](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/nixwiz/sensu-plugins-check_nwc_health) [![TravisCI Build Status](https://travis-ci.org/nixwiz/sensu-plugins-check_nwc-health.svg?branch=master)
](https://travis-ci.org/nixwiz/sensu-plugins-check_nwc-health)

# Sensu Go check_nwc_health Plugin

- [Overview](#overview)
- [Usage examples](#usage-examples)
- [Configuration](#configuration)
  - [Asset registration](#asset-registration)
  - [Asset configuration](#asset-configuration)
  - [Check configuration](#resource-configuration)
- [Functionality](#functionality)
- [Installation from source and contributing](#installation-from-source-and-contributing)

## Overview

This is **NOT** published to Bonsai yet, but putting all this here in advance.

This plugin provides check_nwc_health, a Perl based SNMP check in a format to be used as a Sensu Go asset.  It makes use of the [Sensu Perl Runtime][5], another asset.  The original source code and documentation can be found on the [authors site][3] and [Github][4].

## Configuration

### Asset Registration

Assets are the best way to make use of this plugin. If you're not using an asset, please consider doing so! If you're using sensuctl 5.13 or later, you can use the following command to add the asset: 

`sensuctl asset add nixwiz/sensu-plugins-check_nwc_health`

If you're using an earlier version of sensuctl, you can find the asset on the [Bonsai Asset Index](https://bonsai.sensu.io/assets/nixwiz/sensu-plugins-check_nwc_health).

### Asset configuration

```yml
---
type: Asset
api_version: core/v2
metadata:
  name: check_nwc_health
spec:
  url: https://github.com/nixwiz/sensu-plugin-check_nwc_health/releases/
  sha512: CHANGEME
```

### Check configuration

Example Sensu Go definition:

```yml
---
api_version: core/v2
type: Check
metadata:
  namespace: default
  name: check_router_interface_usage
spec:
  command: check_nwc_health --hostname router.example.com --community public --mode interface-usage --multiline --morphperfdata ' '=''
  handlers:
  - slack
  interval: 30
  output_metric_format: nagios_perfdata
  output_metric_handlers: influxdb
  proxy_entity_name: "router.example.com"
  publish: true
  runtime_assets:
  - sensu-perl-runtime
  - sensu-plugins-check_nwc_health
  subscriptions:
  - snmp_proxy
  timeout: 10
  ttl: 0
```

### Functionality

This plugin requires the Sensu Perl Runtime to function.  All of the Perl modules required by this plugin are provided by the runtime.

For usage documentation, please see the upstream Github[4].

## Installation from source and contributing

The preferred way of installing and deploying this plugin is to use it as an asset. If you would like to compile and install the plugin from source or contribute to it, download the latest version from the original author's upstream [site][3] or [Github][4].

For more information about contributing to this plugin, see https://github.com/sensu/sensu-go/blob/master/CONTRIBUTING.md

[1]: https://github.com/nixwiz/sensu-plugin-check_nwc_health/releases
[2]: #asset-registration
[3]: https://labs.consol.de/nagios/check_nwc_health/index.html
[4]: https://github.com/lausser/check_nwc_health
[5]: https://bonsai.sensu.io/nixwiz/sensu-perl-runtime

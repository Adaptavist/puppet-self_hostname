# self_hostname Module

## Overview

The **self_hostname** module update /etc/hosts records and sets hostname

## Configuration

The following parameters are configurable in Hiera.

* `ensure_canonical_hostname` sets 127.0.0.1 to localhost instead of hostname
* `remove_hostname` removes 127.0.1.1 from /etc/hosts

## Example

```
self_hostname::ensure_canonical_hostname: 'true'

```

## Dependencies

* puppetlabs/stdlib


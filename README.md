# F-Droid Web Services

Dev-ops scripts for deploying/maintaining F-Droids web infrastructure.

## general infos

### install ansible dependencies

```
ansible-galaxy install -f -r requirements.yml
```

## deployments

### link

Deployment scripts for [fdroid.link](https://fdroid.link). A minimal apache +
mod\_md setup. Its sole purpose is to host
[fdroid-link-js](https://gitlab.com/fdroid/fdroid-link-js).

### originserver

The _originserver_ is F-Droids centeral webserver and currently provides
following services:

* Hosts all the files are available on f-droid.org. This includes F-Droids
  website, repo and archive.
* Runs Apache
  [`type-map`](https://httpd.apache.org/docs/current/content-negotiation.html#type-map)
  based content negotiation for automatic locale selection.
* Receives all the repo files from the _buildserver_.
* Pushes all the repo files to the [primary
  mirrors](https://f-droid.org/docs/Running_a_Mirror/).

### reverse proxies (fronters/endpints, certmachine)

These servers terminate HTTP and HTTPS for [f-droid.org](https://f-droid.org).
They're currently confgured to do round robin DNS.

This setup uses nginx as HTTP server, certbot for automating retreival of TLS
certificates and open ssh for network tunnelning and pushing files from our
certmachine server to http-endpoints.

```
                                                    \
  o----------o  o----------o           o----------o  | http reverse
  |          |  |          |           |          |  | proxies with
  |  http01  |  |  http02  |   . . .   |  http n  |  | caching and
  |          |  |          |           |          |  | round robin
  o----------o  o----------o           o----------o  | dns setup
     ^    ^        ^    ^                 ^    ^    /
     |    |        |    |                 |    |
     |    o-------------o----------------------o
     |             |                      |    |
     o-------------o----------------------o    |
     |                                         |
     |                                         |    \
     |                             o-------------o   | managing
     |                             |             |   | tls certs
     |                             | certmachine |   | (certbot)
     |                             |             |   |
     |                             o-------------o   |
     |                                              /
     |
     |                                              \
  o--------------o                                   |
  |              |                                   | central
  | originserver |                                   | web server
  |              |                                   |
  o--------------o                                   |
                                                    /
```

### onion

F-Droids official onion service.

[fdroidorg6cooksyluodepej4erfctzk7rrjpjbbr6wx24jh3lqyfwyd.onion](http://fdroidorg6cooksyluodepej4erfctzk7rrjpjbbr6wx24jh3lqyfwyd.onion)

This setup could deploy multiple onion service servers, however we're currently
just operating one. Right now ansible roles assume that a correctly configured
hidden service dir is already in place.

```
                                                     \
  o-----------o  o-----------o         o-----------o  | http reverse
  |           |  |           |         |           |  | proxies with
  |  onion01  |  |  onion02  |  . . .  |  onion n  |  | caching and
  |           |  |           |         |           |  | a tor onion
  o-----------o  o-----------o         o-----------o  | service
     ^              ^                     ^          /
     |              |                     |
     o--------------o---------------------o
     |
     |                                               \
  o--------------o                                    |
  |              |                                    | upstream
  | originserver |                                    | web server
  |              |                                    |
  o--------------o                                    |
                                                     /
```

The actual onion service hostname should only be used for the HTTP connections.
No other service should be run on it.  For example, the SSH connection should
either be directly to an IP address or via a dedicated onion service hostname.
The Ansible inventory hostname should be the HTTP onion service hostname, then
the operator will need to map that to the IP address or SSH onion service in
their SSH config (e.g. `~/.ssh/config`).

### monitor

Deployment scripts for [F-Droid
monitor](https://gitlab.com/fdroid/fdroid-monitor).

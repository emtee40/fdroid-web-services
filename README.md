This project automates the setup arbitrary amount reverse proxies reverse
proxies in front of a central web server known as the _originserver_.

### _originserver_

The _originserver_ is the server in the middle of all the web services:

* Hosts all the files that are available on f-droid.org.
* Runs Apache [`type-map`](https://httpd.apache.org/docs/current/content-negotiation.html#type-map) for automatic locale selection.
* Receives all the repo files from the _buildserver_.
* Pushes all the repo files to the [primary mirrors](https://f-droid.org/docs/Running_a_Mirror/).

### HTTPS

This setup uses nginx as http server, certbot for automating retreival of tls
certificates and open ssh for network tunnelning and pushing files from
cert-server to http-endpoints. It's scripted with ansible and targeting Debian
bullseye servers.

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
     |                             o-------------o   | maching for
     |                             |             |   | tls certs
     |                             | cert-server |   | (certbot)
     |                             |             |   |
     |                             o-------------o   |
     |                                              /
     |
     |                                              \
  o--------------o                                   |
  |              |                                   | upstream
  | originserver |                                   | web server
  |              |                                   |
  o--------------o                                   |
                                                    /
```

### HTTP over .onion

The setup for running our tor onion service servers is straight forward.  Right
now ansible roles assume a correctly configured hidden service dir is already
in place.

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

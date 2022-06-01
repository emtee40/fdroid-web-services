This project automates the setup arbitrary ammount reverse proxies rverse
proxies in front of a central webserver.

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
  o--------------o                                   | upstream
  |              |                                   | web server
  |  web-server  |                                   | (not managed
  |              |                                   | in this proj)
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
  o--------------o                                    | upstream
  |              |                                    | web server
  |  web-server  |                                    | (not managed
  |              |                                    | in this proj)
  o--------------o                                    |
                                                     /
```

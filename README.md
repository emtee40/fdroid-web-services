This project automates the setup arbitrary ammount reverse proxies rverse
proxies in front of a central webserver.

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

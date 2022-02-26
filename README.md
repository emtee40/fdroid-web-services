This project automates the setup arbitrary ammount reverse proxies rverse
proxies in front of a central webserver.

This setup uses nginx as http server, certbot for automating retreival of tls
certificates and open ssh for network tunnelning and pushing files from
cert-server to http-endpoints. It's scripted with ansible and targeting Debian
bullseye servers.

```
                                                     \
  o----------o  o----------o           o----------o  |
  |          |  |          |           |          |  | http endpoints
  |  http01  |  |  http02  |   . . .   |  http n  |  | with caching
  |          |  |          |           |          |  | (round robin
  o----------o  o----------o           o----------o  |  dns)
     ^    ^        ^    ^                 ^    ^     /
     |    |        |    |                 |    |
     |    o-------------o----------------------o
     |             |                      |    |
     o-------------o----------------------o    |
     |                                         |     \
  o-------------o                              |     |
  |             |                              |     | (certMachine)
  |  cert-serv  |                              |     | certbot runs
  |             |                              |     | here
  o-------------o                              |     |
                                               |     /
                                               |
                                               |     \
                                   o--------------o  |
                                   |              |  | upstream
                                   |  web-server  |  | web server
                                   |              |  | (not managed
                                   o--------------o  | in this proj)
                                                     /
```

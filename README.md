# Media server

[![Pipeline](https://github.com/egnd/hms/workflows/Pipeline/badge.svg)](https://github.com/egnd/hms/actions?query=workflow%3APipeline)
[![Release](https://github.com/egnd/hms/workflows/Release/badge.svg)](https://github.com/egnd/hms/actions?query=workflow%3ARelease)

Services for home media server ([torrent](https://hub.docker.com/r/linuxserver/transmission) and [jellyfin](https://hub.docker.com/r/linuxserver/jellyfin))

### Quick start:
1. Download release from [here](https://github.com/egnd/go-tghandlers/releases)
2. Run with command ```make run```

### Hints:
* To set specific path for torrent's downloads folder, you need to override volume ```torrent-downloads``` by adding to ```docker-compose.override.yml```:
```yaml
volumes:
  torrent-downloads:
    driver_opts:
      type: none
      o: bind
      device: #YOUR_SPECIFIC_ABSOLUTE_OR_RELATIVE_PATH_HERE#
```
* When you need to run this services at your Raspbian, you have to modify ```.env``` file:
  * change value of ```DC_TORRENT_IMAGE``` from ```amd64-latest``` to ```arm32v7-latest```
* To use hardware acceleration at Raspberry Pi, you have to override service ```media``` at ```docker-compose.override.yml```:
  * read [this](https://jellyfin.org/docs/general/administration/hardware-acceleration.html#acceleration-on-docker)
  * for OpenMAX acceleration add this:
```yaml
media:
  volumes:
    - /opt/vc/lib:/opt/vc/lib
  devices:
    - /dev/vcsm:/dev/vcsm
    - /dev/vchiq:/dev/vchiq
```
  * for V4L2 acceleration add this:
```yaml
media:
  devices:
    - /dev/video10:/dev/video10
    - /dev/video11:/dev/video11
    - /dev/video12:/dev/video12
```

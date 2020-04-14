## Webtrees Docker
This container is packaged as a standalone Webtrees server intended to be run with the SQLite database for a hobby-level installation but you can use docker-compose to bundle a standard SQL server to expand functionality. 

## What is Webtrees?

Webtrees is a web application that allows you to publish your genealogy online, collaborate with family members and take control of your data. 

For more information or for Webtrees support please visit https://www.webtrees.net

## Supported Architectures

The container is based on Alpine Linux and will likely compile for any of alpines supported architectures, however, the only image that is compiled and tagged is the x86-64 architecture. 

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=webtrees \
  -v /path/to/data:/data \
  -p 8080:8080
  --restart unless-stopped \
  indemnity83/webtrees
```

### docker-compose

You can use docker-compose or docker stack deploy if you want to bundle a SQL server with the webserver. Scaling the service may work, but is not supported (it goes beyond the intended use case of the image and is not likely considered by the Webtrees application) 

```
---
version: '2.1'

services:

  web:
    image: indemnity83/webtrees
    ports:
      - 8080:8080
    volumes:
      - /path/to/data:/data
  
  db:
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
```

## Application Setup

the Webtrees UI can be found at `http://<your-ip>:8080` (port may be different if you've modified the above examples). Follow the on-screen instructions to get the application setup. 

All persistent configuration data and media will be stored in the attached volume.  

** Automatic updates are not supported, docker images are tied to a specific release. To upgrade Webtrees, download the newest image and restart the container. **


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)

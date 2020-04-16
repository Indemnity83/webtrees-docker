## Webtrees Docker
This container is packaged as a single container Webtrees server, ready to be run with the SQLite database for a hobby-level installation. Or you can bundle MySQL (recomended), PostgreSQL (experimental) or SQL Server (experemental) to expand capability.  

## What is Webtrees?

Webtrees is a 3rd party web application that allows you to publish your genealogy online, collaborate with family members and take control of your data. 

For more information or support with the Webtrees application please visit https://www.webtrees.net

## Image Variants

there is a `webtress:<version>` tag corresponding to specific Webtrees releases if you're looking for a specific version. If you're using a tool that can watch for updates, the `webtress:latest` image will always match the most recent released version that has been compiled. 

## Supported Architectures

The container is based on Alpine Linux and will likely compile for any of Alpines supported architectures, however, the only image that is compiled and tagged is the `linux/amd64`. Feel free to make a PR to expand the build process in Makefile. 

## Usage

Here are some example snippets to help you get started creating a container. 

A reverse proxy is recomended to provide SSL protection for public access.

### docker

```
docker create \
  --name=webtrees \
  -v /path/to/data:/var/www/html/data \
  -p 8080:8080
  -e UPLOAD_LIMIT=20M
  --restart unless-stopped \
  indemnity83/webtrees
```

### docker-compose

You can use docker-compose or docker stack deploy if you want to bundle MySQL with the webserver. For docker stack deployments, scalling the web server is not supported (it goes beyond the intended use case of the image and is not likely considered by the Webtrees application).  

```
---
version: '2.1'

services:

  web:
    image: indemnity83/webtrees
    ports:
      - 8080:8080
    environment:
      - UPLOAD_LIMIT=20M
    volumes:
      - /path/to/data:/var/www/html/data
  
  db:
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
```

## Environment Variables

`UPLOAD_LIMIT`

Sets the maximum allowable upload size. Defaults to 20M.

## Application Setup

the Webtrees UI can be found at `HTTP://<your-ip>:8080` (port may be different if you've modified the above examples). Follow the on-screen instructions to get the application setup. 

All persistent configuration data and media will be stored in the attached volume.  

** Automatic updates are not supported, docker images are tied to a specific release. To upgrade Webtrees, download the newest image and restart the container. **


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/)

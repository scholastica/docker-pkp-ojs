# Run OJS 3.x

_Not actively developed!_

## Docker Compose
Create a *docker-compose.yml* file and run ```docker-compose up```.
```dockerfile
# docker-compose.yml
ojs:
  image: 3.x/.
  ports:
    - 80:80
  links:
    - mysql:db
mysql:
  image: mysql
  environment:
    - MYSQL_ROOT_PASSWORD=root
    - MYSQL_DATABASE=ojs
    - MYSQL_USER=ojs
    - MYSQL_PASSWORD=ojs
```

Run the following commands:
```bash
to do...
```

# Run OJS 2.x

## Start containers

Go to the directory `2.x` and run `docker-compose up`. This will start three containers (for web application, database, and a data container - the latter one will immediately exit again).

You can find out the IP of the web container by running the following command: `docker network inspect 2x_default`.

To find out the name of the network of the just started containers, use `docker network ls`.

Then you can open the installation page at http://<ip of web container>/ojs/index.php.

To change the installation path of OJS to something other than `/ojs`, please see build arguments in `docker-compose.yml`.

### Web container
...

### Database container
...

### Data container
...

## Configuration

Open the installation page at http://[ip of web container]/[path to ojs]/index.php. Make at least the following changes:

* Add admin user credentials
* Change the file upload directory to `/var/ojs/files`
* Set the database host to `db`
* Remove the tick in the checkbox "Create new database". The database was already created in the database container via the `docker-compose.yml`

## Start containers with own configuration

You can run the main containers and additional containers or overwrite settings with the following command:

```
docker-compose -f docker-compose.yml -f docker-compose.myextensions.yml {build, up, stop, start, down, rm}
```

*Be sure to list all these files again when stopping, downing, or removing the containers!*

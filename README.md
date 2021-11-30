# Running ConceptNet on Docker

This repo was forked from [here](https://github.com/commonsense/conceptnet5).

The original build process is outlined [here](https://github.com/commonsense/conceptnet5/wiki/Build-process).

I tried to dockerize things as much as possible so that you can just pull the image and
run it on your desired machine.


## Full Docker image with data (222GB)

First off, this image is huge. Make sure you have enough space in your disk.

This is image is made on top of the barbone one (i.e., `tae898/conceptnet5`) with every
necessary comand and data included. This was made so that you can just use it as one-go.

1. Pull the latest image by

    ```sh
    docker pull tae898/conceptnet5-full
    ```


## Barebone Docker image (1GB)

1. Pull the latest image by

    ```sh
    docker pull tae898/conceptnet5
    ```

    Check out the original [Dockerfile](./Dockerfile) of this image, if interested.  

1. Run the docker container in detached mode. This will start `postgres` within.

    ```sh
    docker run --name conceptnet5 --network host -d tae898/conceptnet5
    ```

1. Open up zsh (or bash, whatever you prefer) in the container by running

    ```sh
    docker exec -it conceptnet5 zsh
    ```

1. Create a PostgreSQL database named conceptnet5 by running

    ```sh
    createdb conceptnet5
    ```

1. Start the build by running

    ```sh
    ./build.sh
    ```

    This will take a long time since it has to download all the data.
    You need at least 30 GB of available RAM, 300 GB of free disk space, and the time
    and bandwidth to download 24 GB of raw data.

1. At this point (30-Nov-2021), some changes have to be made to the master branch
    ```sh
    diff --git a/build.sh b/build.sh
    index 65bd85c..c721192 100755
    --- a/build.sh
    +++ b/build.sh
    @@ -30,4 +30,4 @@ check_db () {
    check_disk_space
    pip3 install -e '.[vectors]'
    check_db
    -snakemake --resources 'ram=30' -j 2 $@
    +snakemake --resources 'ram=30' -j$(nproc)  $@
    diff --git a/conceptnet5/db/query.py b/conceptnet5/db/query.py
    index 86fe021..afca7f6 100644
    --- a/conceptnet5/db/query.py
    +++ b/conceptnet5/db/query.py
    @@ -125,7 +125,7 @@ class AssertionFinder(object):
            self.dbname = dbname
    
        @property
    -    def connection():
    +    def connection(self):
            # See https://www.psycopg.org/docs/connection.html#connection.closed
            if self._connection is None or self._connection.closed > 0:
                self._connection = get_db_connection(self.dbname)
    diff --git a/web/conceptnet_web/api.py b/web/conceptnet_web/api.py
    index 3392105..9b7d322 100644
    --- a/web/conceptnet_web/api.py
    +++ b/web/conceptnet_web/api.py
    @@ -6,6 +6,7 @@ import os
    import flask
    from flask_cors import CORS
    from flask_limiter import Limiter
    +from flask_limiter.util import get_remote_address
    
    from conceptnet5 import api as responses
    from conceptnet5.api import VALID_KEYS, error
    @@ -37,7 +38,8 @@ app.config.update({
    for filter_name, filter_func in FILTERS.items():
        app.jinja_env.filters[filter_name] = filter_func
    app.jinja_env.add_extension('jinja2_highlight.HighlightExtension')
    -limiter = Limiter(app, global_limits=["600 per minute", "6000 per hour"])
    +limiter = Limiter(app, key_func=get_remote_address, 
    +                  global_limits=["600 per minute", "6000 per hour"])
    CORS(app)
    try_configuring_sentry(app)
    application = app  # for uWSGI
    ```

1. Run the web server

    ```sh
    cd web
    pip install -e .
    python3 conceptnet_web/api.py
    ```

1. When you are done you can just kill the container. And when you wanna start again, 
first run
    ```sh
    docker start conceptnet5
    ```
    Now the container `conceptnet5` started in detached mode. Now run the Flask API server by

    ```sh
    docker exec -it -w /conceptnet5/web conceptnet5 python3 conceptnet_web/api.py
    ```

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
1. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
1. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
1. Push to the Branch (`git push origin feature/AmazingFeature`)
1. Open a Pull Request

## Authors

- [Taewoon Kim](https://taewoonkim.com/)

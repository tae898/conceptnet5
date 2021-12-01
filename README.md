# Running ConceptNet on Docker

This repo was forked from [here](https://github.com/commonsense/conceptnet5).

The original build process is outlined [here](https://github.com/commonsense/conceptnet5/wiki/Build-process).

I tried to dockerize things as much as possible so that you can just pull the image and
run it on your desired machine.

## Docker image (1.02GB compressed size, 2.488GB uncompressed size)

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

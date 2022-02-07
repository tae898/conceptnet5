# Running ConceptNet Locally on Docker

[![DOI](https://zenodo.org/badge/432499469.svg)](https://zenodo.org/badge/latestdoi/432499469)

Watch the tutorial video at [here](https://youtu.be/UAM1XwbpOZI).

This repo was forked from [here](https://github.com/commonsense/conceptnet5).

The original build process is outlined [here](https://github.com/commonsense/conceptnet5/wiki/Build-process).

I tried to dockerize things as much as possible so that you can just pull the image and
run it on your desired machine.

## Pulling and running the Docker image (1.02GB compressed size, 2.488GB uncompressed size)

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

1. Now you are ready to play around with the API!

   Try: http://127.0.0.1:8084/c/en/laptop?rel=/r/AtLocation&limit=1000

   Any HTTP request with the original server (e.g., https://conceptnet.io/c/en/laptop?rel=/r/AtLocation&limit=1000) will work on your local machine now.
   The only difference is that now the external server https://conceptnet.io is replaced with your local server http://127.0.0.1:8084.

1. You can also make HTTP requests from a python client. Take a look at the [client.py](./client.py)

   Be sure to install the requests package by running `pip install requests`

1. When you are done with the API, you can safely turn off the Flask server and kill the docker container by

   ```sh
   docker kill conceptnet5
   ```

## Running the docker container and the API agian

1. When you are done you can just kill the container. And when you wanna start again,
   first run

   ```sh
   docker start conceptnet5
   ```

   Now the container `conceptnet5` started in detached mode. Now run the Flask API server by

   ```sh
   docker exec -it -w /conceptnet5/web conceptnet5 python3 conceptnet_web/api.py
   ```

1. Again when you are done, kill the container by

   ```sh
   docker kill conceptnet5
   ```
   
## Troubleshooting

The best way to find and solve your problems is to see in the github issue tab. If you can't find what you want, feel free to raise an issue. We are pretty responsive.

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
1. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
1. Run `make style && quality` in the root repo directory, to ensure code quality.
1. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
1. Push to the Branch (`git push origin feature/AmazingFeature`)
1. Open a Pull Request

## Authors

- [Taewoon Kim](https://taewoonkim.com/)

"""Simple client to making RESTful requests to the server."""
import argparse
import json
import logging
import os

import requests

logging.basicConfig(
    level=os.environ.get("LOGLEVEL", "INFO").upper(),
    format="%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)


def write_json(content: dict, fname: str) -> None:
    """Write json.

    Args
    ----
    content: content to write.
    fname: filename to be saved.

    """
    logging.debug(f"writing json {fname} ...")
    with open(fname, "w") as stream:
        json.dump(content, stream, indent=4, sort_keys=False)


def main(server_address: str, object_: str) -> None:
    """Make a HTTP get request to the server and print out the response.

    Args
    ----
    server_address: server address
    """

    query = f"{server_address}/query?start=/c/en/{object_}&rel=/r/AtLocation"
    response = requests.get(query).json()
    print(response)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="simple client")
    parser.add_argument(
        "--server_address",
        type=str,
        default="http://api.conceptnet.io",
        help="http://api.conceptnet.io" or "http://127.0.0.1:8084",
    )

    parser.add_argument(
        "--object",
        type=str,
        default="laptop",
        help="laptop, baseball, person, etc.",
    )

    args = parser.parse_args()

    main(args.server_address, args.object)

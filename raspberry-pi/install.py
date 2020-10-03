#!/usr/bin/env python3

import argparse
import os
import subprocess


ROOT_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
BLUETOOTH_SERVER_DIRECTORY = os.path.join(ROOT_DIRECTORY, "bluetooth-server")


class Chdir(object):

    def __init__(self, path):
        self.path = os.path.abspath(path)

    def __enter__(self):
        self.previous = os.getcwd()
        os.chdir(self.path)

    def __exit__(self, *args):
        os.chdir(self.previous)


def main():
    parser = argparse.ArgumentParser(description="Set up the Raspberry Pi for use with Compute.")
    options = parser.parse_args()

    print("Installing node dependencies...")
    with Chdir(BLUETOOTH_SERVER_DIRECTORY):
        subprocess.check_call(["npm", "install"])


if __name__ == "__main__":
    main()

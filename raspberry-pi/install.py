#!/usr/bin/env python3

import argparse
import logging
import os
import subprocess
import tempfile

import jinja2


ROOT_DIRECTORY = os.path.dirname(os.path.abspath(__file__))
BLUETOOTH_SERVER_DIRECTORY = os.path.join(ROOT_DIRECTORY, "bluetooth-server")

BLUETOOTH_SERVER_SERVICE_TEMPLATE_PATH = os.path.join(ROOT_DIRECTORY, "bluetooth-server.service")


class Chdir(object):

    def __init__(self, path):
        self.path = os.path.abspath(path)

    def __enter__(self):
        self.previous = os.getcwd()
        os.chdir(self.path)

    def __exit__(self, *args):
        os.chdir(self.previous)

        
def install_node_dependencies():
    print("Installing node dependencies...")
    with Chdir(BLUETOOTH_SERVER_DIRECTORY):
        subprocess.check_call(["npm", "install"])


def install_bluetooth_server_service():
    print("Creating bluetooth-server service...")
    with open(BLUETOOTH_SERVER_SERVICE_TEMPLATE_PATH, "r") as fh:
        template = jinja2.Template(fh.read())
    with tempfile.NamedTemporaryFile() as temporary_file:
        contents = template.render(working_directory=BLUETOOTH_SERVER_DIRECTORY)
        temporary_file.write(contents.encode('utf-8'))
        temporary_file.flush()
        subprocess.check_call(["sudo", "cp", temporary_file.name, "/lib/systemd/system/bluetooth-server.service"])
    print("Enabling service...")
    subprocess.check_call(["sudo", "systemctl", "enable", "bluetooth-server.service"])
    print("Starting service...")
    subprocess.check_call(["sudo", "systemctl", "start", "bluetooth-server.service"])
        

def main():
    parser = argparse.ArgumentParser(description="Set up the Raspberry Pi for use with Compute.")
    options = parser.parse_args()

    install_node_dependencies()
    install_bluetooth_server_service()


if __name__ == "__main__":
    main()

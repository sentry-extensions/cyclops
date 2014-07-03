#! /usr/bin/env python

import argparse

from cyclops.config import Config

def main():
    parser = argparse.ArgumentParser(description="Generate an example configuration file")
    parser.add_argument("path", help="Path to configuration file.")
    args = parser.parse_args()

    generate_configuration_file(args.path)

def generate_configuration_file(path):
    with open(path, 'w') as f:
        f.write(Config().get_config_text())

if __name__ == "__main__":
    main()

#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import argparse

import requests


def get_count(host, port):
    url = 'http://%s:%d/count' % (host, port)
    try:
        r = requests.get(url)
        return int(r.text)
    except:
        print "Failed to get count for %s." % url
        return 0


def main(args=None):
    if args is None:
        args = sys.argv[1:]

    parser = argparse.ArgumentParser()
    parser.add_argument('--host', '-b', help="Host to get count from.")
    parser.add_argument('--ports', '-p', help="Ports to get count from. Format: [Starting-Last] Example: 9900-9999")

    options = parser.parse_args(args)

    starting, last = options.ports.split('-')
    starting = int(starting)
    last = int(last)

    count = 0
    for port in range(last - starting):
        server_count = get_count(options.host, starting + port)
        print "%s:%d has still %d messages to process" % (options.host, starting + port, server_count)
        count += server_count

    print
    print "Total of %d messages to send to sentry from the farm at %s." % (count, options.host)
    print


if __name__ == '__main__':
    main(sys.argv[1:])

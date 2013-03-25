#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import argparse
from ujson import loads

import requests


def get_count(host, port):
    url = 'http://%s:%d/count' % (host, port)
    try:
        r = requests.get(url)
        obj = loads(r.text)

        return obj
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

    total_request_time = 0
    percentile_request_time = 0
    number_of_servers = 0
    number_of_servers_with_average = 0
    number_of_servers_with_percentile = 0

    count = 0
    for port in range(last - starting + 1):
        number_of_servers += 1

        server_count = get_count(options.host, starting + port)
        print "%s:%d has still %d messages to process" % (options.host, starting + port, server_count['count'])
        count += server_count['count']

        if server_count['average']:
            total_request_time += server_count['average']
            number_of_servers_with_average += 1

        if server_count['percentile']:
            percentile_request_time += server_count['percentile']
            number_of_servers_with_percentile += 1

    if number_of_servers_with_average == 0:
        number_of_servers_with_average = 1

    if number_of_servers_with_percentile == 0:
        number_of_servers_with_percentile = 1

    print
    print "Total of %d messages to send to sentry from the farm at %s." % (count, options.host)
    print
    print "Average sentry response time is %.2fms and 90%% Percentile is %.2fms" % (
        float(total_request_time) / number_of_servers_with_average,
        float(percentile_request_time) / number_of_servers_with_percentile
    )
    print


if __name__ == '__main__':
    main(sys.argv[1:])

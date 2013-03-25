![Cyclops is meant to be a high performance barrier in front of [sentry](http://getsentry.com)](/logo.png)

Disclaimer
==========

I am a huge fan of [sentry](http://getsentry.com) and it has literally changed the level of quality of all my apps that use it, web or not.

Huge props to the whole team behind it and to @disqus for releasing it to the public as open source, thus allowing us to better understand how it works.

The Issue
=========

That said, if you have a volume of requests as large as we do (> 5000 requests/second), a single Javascript error being tracked by [sentry](http://getsentry.com) could bring our whole [sentry](http://getsentry.com) farm down.

We did some extensive Load Testing with [sentry](http://getsentry.com) and the results will be available to everyone soon. It's just not viable for us to have [sentry](http://getsentry.com) as the Front End to our error reporting.

We needed something that could handle tens of thousands of error reporting requests per second, then send it to [sentry](http://getsentry.com) in a rate that it can process.

Cyclops
=======

Cyclops is a router of [sentry](http://getsentry.com) error reporting requests. It receives error reports, keeps them in-memory (or any other storage you implement) and sends to your [sentry](http://getsentry.com) backend in regular intervals.

It takes into account the time your [sentry](http://getsentry.com) backend is taking to service each request when calculating the interval with which to send the next request, thus making sure you don't flood your [sentry](http://getsentry.com) backend.

In our Load Testing, a server with 23 instances of Cyclops running handled more than 12 thousand requests per second.

Installing
==========

Installing Cyclops is as easy as:

    $ pip install cyclops

Usage
=====

Cyclops comes with a console app called 'cyclops' (pretty imaginative bunch, aren't we?).

    $ cyclops --help
    usage: cyclops [-h] [--port PORT] [--bind BIND] [--conf CONF] [--verbose]
                 [--debug]

    optional arguments:
      -h, --help            show this help message and exit
      --port PORT, -p PORT  Port to start the server with.
      --bind BIND, -b BIND  IP to bind the server to.
      --conf CONF, -c CONF  Path to configuration file.
      --verbose, -v         Log level: v=warning, vv=info, vvv=debug.
      --debug, -d           Indicates whether to run tornado in debug mode.

The arguments are pretty explanatory. The key argument is the configuration file.

Configuration
=============

The configuration file is where you tell Cyclops how to behave, how to store data, how to connect to [sentry](http://getsentry.com), etc.

    ################################### General ####################################

    ## Cyclops has a /healthcheck route. This allows load balancers to ping it to see
    ## if the process is still alive. This option defines the text that the
    ## /healthcheck route prints.
    ## Defaults to: WORKING
    #HEALTHCHECK_TEXT = 'WORKING'

    ## [sentry](http://getsentry.com) server name. This is the base URL that Cyclops will use to send
    ## requests to [sentry](http://getsentry.com).
    ## Defaults to: localhost:9000
    #[sentry](http://getsentry.com)_BASE_URL = 'localhost:9000'

    ## Cyclops keeps [sentry](http://getsentry.com)'s projects public and security keys in memory. This
    ## allows a very fast validation as to whether each request is valid. This
    ## configuration defines the interval in seconds that Cyclops will update the
    ## keys.
    ## Defaults to: 120
    #UPDATE_PERIOD = 120

    ## The storage class used in Cyclops. Storage classes are what define how
    ## received requests will be treated *before* sending to [sentry](http://getsentry.com). Inherits from
    ## cyclops.storage.base.Storage. Built-ins: "cyclops.storage.memory" and
    ## "cyclops.storage.redis."
    ## Defaults to: cyclops.storage.memory
    #STORAGE = 'cyclops.storage.memory'

    ################################################################################


    ################################# Performance ##################################

    ## Cyclops will try to send the errors it receives to [sentry](http://getsentry.com) as fast as possible.
    ## This is done using a percentile average of 90% of the last [sentry](http://getsentry.com) requests
    ## time. If those requests were serviced in 30ms average, then Cyclops will
    ## keep sending requests every 30ms. This setting specify a maximum interval
    ## in miliseconds to send requests to [sentry](http://getsentry.com).
    ## Defaults to: 1000
    #MAX_DUMP_INTERVAL = 1000

    ## In order to calculate the average requests, Cyclops keeps track of the times
    ## of the last requests sent to [sentry](http://getsentry.com). This setting specifies the maximum
    ## number of requests to average.
    ## Defaults to: 5000
    #MAX_REQUESTS_TO_AVERAGE = 5000

    ################################################################################


    ################################### Database ###################################

    ## Host of your [sentry](http://getsentry.com) installation MySQL database.
    ## Defaults to: localhost
    #MYSQL_HOST = 'localhost'

    ## Port of your [sentry](http://getsentry.com) installation MySQL database.
    ## Defaults to: 3306
    #MYSQL_PORT = 3306

    ## Database of your [sentry](http://getsentry.com) installation MySQL database.
    ## Defaults to: [sentry](http://getsentry.com)
    #MYSQL_DB = '[sentry](http://getsentry.com)'

    ## User of your [sentry](http://getsentry.com) installation MySQL database.
    ## Defaults to: root
    #MYSQL_USER = 'root'

    ## Password of your [sentry](http://getsentry.com) installation MySQL database.
    ## Defaults to: 
    #MYSQL_PASS = ''

    ################################################################################

The Routes
==========

Cyclops mymics the `api/store` routes in [sentry](http://getsentry.com). Both the GET and POST routes.

You can send the errors to Cyclops in *EXACTLY* the same way you would send to [sentry](http://getsentry.com).

There's one additional route, though: `/count`.

This route returns a JSON object that tells you how that specific Cyclops instance is doing (how many messages to process, average and percentile response time).

An example output of the `/count` route:

    {
    count: 0,
    average: 77.491357729,
    percentile: 72.9767654253
    }

cyclops-count
=============

Using the `/count` route, we can keep track of the performance of individual Cyclops instances and of the load of each of them. It would be a tedious task to track the load and performance of each instance, though.

Cyclops comes with a helper program that allows you to specify a server and a range of ports representing Cyclops instances, like this:

    $ cyclops-count -b http://localhost -p 9000-9004

This command would return output similar to:

    localhost:9000 has still 10 messages to process
    localhost:9001 has still 10 messages to process
    localhost:9002 has still 10 messages to process
    localhost:9003 has still 10 messages to process
    localhost:9004 has still 10 messages to process

    Total of 50 messages to send to [sentry](http://getsentry.com) from the farm at localhost.

    Average [sentry](http://getsentry.com) response time is 2918.66ms and 90% Percentile is 2339.53ms

This way you can keep track of how your farm is doing *A LOT* easier.

Hosting
=======

The way we are hosting Cyclops is pretty standard.

We have a [supervisor](http://supervisord.org/) instance that starts 24 instances of Cyclops in ports ranging from 9100 to 9123.

We then use NGinx to load-balance traffic to them, and use the NGinx port to send [sentry](http://getsentry.com) traffic to. If anyone is interested in a sample configuration for both supervisor and NGinx, just create an issue.

Contributing
============

If you wish to contribute to Cyclops, file and issue or send us a pull request.

License
=======

Cyclops is licensed under the MIT License:

    The MIT License

    Copyright (c) 2013 Bernardo Heynemann heynemann@gmail.com

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup, find_packages
from cyclops import __version__

mysql_requires = [
    'torndb==0.1',
    'MySQL-python'
]
tests_require = mysql_requires + [
    'nose',
    'coverage',
    'yanc',
    'preggy',
    'nose',
]

setup(
    name='cyclops',
    version=__version__,
    description="cyclops is a high-performance gateway for sentry.",
    long_description="""
cyclops is a high-performance gateway for sentry.
It keeps items in memory and dumps them at sentry in regular intervals.
""",
    keywords='bug monitoring tornado',
    author='Bernardo Heynemann',
    author_email='heynemann@gmail.com',
    url='https://github.com/heynemann/cyclops',
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Operating System :: MacOS',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
    ],

    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,

    extras_require={
        'tests': tests_require,
        'mysql': mysql_requires,
    },

    install_requires=[
        'tornado>=3.0.0',
        'derpconf==0.3.3',
        'pycurl==7.19.0',
        'requests==1.1.0',
        'ujson==1.30',
        'msgpack-python==0.3.0',
        'redis==2.7.2',
        'redis-lock==0.2.0',
        'argparse==1.2.1',
    ],

    entry_points={
        'console_scripts': [
            'cyclops=cyclops.server:main',
            'cyclops-init=cyclops.init:main',
            'cyclops-count=cyclops.count:main',
        ],
    }
)

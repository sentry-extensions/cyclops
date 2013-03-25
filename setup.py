#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup, find_packages
from cyclops import __version__

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

    install_requires=[
        'tornado',
        'torndb',
        'derpconf',
        'pycurl',
        'requests',
        'ujson',
        'msgpack-python'
    ],

    entry_points={
        'console_scripts': [
            'cyclops=cyclops.server:main',
            'cyclops-count=cyclops.count:main',
        ],
    }
)

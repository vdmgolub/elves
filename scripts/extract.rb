#!/usr/bin/env ruby

path = ARGV.shift

`curl -X POST -d path=#{path} 127.0.0.1:8000/extract`

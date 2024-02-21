#!/bin/bash
docker build -t host-misaev -f _misaev-1_host .
docker build -t router-misaev -f _misaev-2 .

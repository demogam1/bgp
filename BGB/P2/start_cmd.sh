#!/bin/bash
docker build -t routeur_misaev -f _misaev-2 .
docker build -t host_misaev -f _misaev-1_host .

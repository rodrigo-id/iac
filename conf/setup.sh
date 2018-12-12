#!/bin/bash
sed -i "/loopback/s/$/ $HOSTNAME/" /etc/hosts

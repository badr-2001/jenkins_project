#!/bin/bash
# ==========================
# Simple SSH connection script
# ==========================

USER="ubuntu"
HOST="34.240.2.243"
PORT=22
KEY_PATH="/home/badr/.ssh/bei_key"

echo "Connecting to $USER@$HOST ..."
ssh -i "$KEY_PATH" -p $PORT $USER@$HOST

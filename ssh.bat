@echo off
REM ==========================
REM Single SSH connection
REM ==========================

set USER=ubuntu
set HOST=34.240.2.243
set PORT=22
set KEY_PATH=/mnt/c/Users/Admin/.ssh/bei_key

ssh -i "%KEY_PATH%" -p %PORT% %USER%@%HOST%

# processmaker_dockerimage
Builds a process maker docker image

https://github.com/ProcessMaker/pm4core-docker supplies a docker image that will
download and install processmaker every time it is run!! Startup time is horrible.

This image does the processmaker downlaod and install in the build phase and the
image will just launch processmaker when run.
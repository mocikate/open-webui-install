#!/bin/bash

docker build -t buildapp:test .   
docker run -tid --name open-webui-build --entrypoint=/bin/sh --env container=docker   --mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup --mount type=bind,source=/sys/fs/fuse,target=/sys/fs/fuse  --mount type=tmpfs,destination=/tmp --mount type=tmpfs,destination=/run --mount type=tmpfs,destination=/run/lock buildapp:test --log-level=info --unit=sysinit.target
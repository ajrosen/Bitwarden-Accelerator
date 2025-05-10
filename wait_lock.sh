#!/bin/bash

/usr/bin/swift \
    -e 'import Cocoa'\
    -e 'DistributedNotificationCenter.default().addObserver(' \
    -e 'forName: .init("com.apple.screenIsLocked"), object: nil, queue: .main)' \
    -e '{ notification in exit(0) }' \
    -e 'RunLoop.main.run()'

if [ $? == 0 ]; then
    osascript -e 'tell application id "com.runningwithcrayons.Alfred" to run trigger "lock" in workflow "org.mlfs.corp.bw"'
fi

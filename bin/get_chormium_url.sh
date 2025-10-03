#!/bin/bash

osascript -e "tell application id \"${focusedapp}\" to get URL of active tab of first window"

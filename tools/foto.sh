#!/bin/bash
while read i; do if [ "$i" = foto.png ]; then \
    mv tmp/foto.png ~/Pictures/PETTILmobile/foto/foto-$(date +%a-%F-%H-%M-%S.%N).png; fi; done \
   < <(inotifywait  -e create,open --format '%f' --quiet ./tmp --monitor)

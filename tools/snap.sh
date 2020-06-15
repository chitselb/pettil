while read i; do if [ "$i" = snapshot.vsf ]; then \
    mv snapshot.vsf data/foto/snapshot-$(date +%a-%F-%H-%M-%S.%N).vsf; fi; done \
   < <(inotifywait  -e create,open --format '%f' --quiet ./ --monitor)

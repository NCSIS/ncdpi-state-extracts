## Extracts final 301 location for a given list of URLs.
## Written by John Mairs, January 2025
## Intended to get the full URLs for NCSIS Infinite Campus instances.

## Input is 'Get301NewLocations.txt' and should have one URL per line.
## Output is 'Got301NewLocations.txt'

#!/bin/bash
while read LINE; do
  curl -Ls -o /dev/null -w %{url_effective} $LINE
  printf "\n"
done < Get301NewLocations.txt > Got301NewLocations.txt
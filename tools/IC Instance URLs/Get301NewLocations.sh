## Extracts final 301 location for a given list of URLs.
## Written by John Mairs, January 2025
## Intended to get the full URLs for NCSIS Infinite Campus instances.
## Used with this Google Sheet: https://docs.google.com/spreadsheets/d/1lc-rdZyOo2hoBgHNHyjdTFCVSv79oRucNmzMRgCReZg/

## Input is 'urls.txt' and should have one URL per line.
## Output is '301NewLocations.txt'

#!/bin/bash
while read LINE; do
  curl -Ls -o /dev/null -w %{url_effective} $LINE
  printf "\n"
done < urls.txt > 301NewLocations.txt
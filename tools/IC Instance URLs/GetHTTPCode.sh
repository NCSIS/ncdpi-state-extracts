## Extracts the HTTP status for a given list of URLs.
## Written by John Mairs, January 2025
## Intended to see if NCSIS Infinite Campus instances exist.

## Input is 'urls.txt' and should have one URL per line.
## Output is 'HTTPCode.txt'

#!/bin/bash
while read LINE; do
  curl -o /dev/null --silent --head --write-out "%{http_code}\n" $LINE
done < urls.txt > HTTPCode.txt
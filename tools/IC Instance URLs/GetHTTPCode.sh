## Extracts the HTTP status for a given list of URLs.
## Written by John Mairs, January 2025
## Intended to see if NCSIS Infinite Campus instances exist.
## Used with this Google Sheet: https://docs.google.com/spreadsheets/d/1lc-rdZyOo2hoBgHNHyjdTFCVSv79oRucNmzMRgCReZg/

## Input is 'saml_urls.txt' and should have one URL per line.
## Output is 'HTTPCode.txt'

#!/bin/bash
while read LINE; do
  curl -o /dev/null --silent --head --write-out "%{http_code}\n" $LINE
done < saml_urls.txt > HTTPCode.txt
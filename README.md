# GeoIpLocator
This script analyses your auth.log for failed attempts that hackers try to log into your SSH Server.

# Output files
This will create 3 files
* country.txt - Contains the GeoIP information for their respected IPs
* geoIP.txt - Cotains the GeoIPs
* sortedips.txt - Contains the sorted by unqiue GeoIPs

# How to run
This script needs sudo privileges. So run with sudo.
```bash
sudo ./GeoIpLocator.sh
```

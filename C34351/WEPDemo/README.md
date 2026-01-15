# WEPDemo
Files for the WEP demo.

Notes:
- Run `sudo ./setup.sh [-c|-s]` to setup the necessary software on the client and the server.
- Both the client and the server should use *static* IP-addresses on their `wlan0` interfaces and the IP-addresses must be used in the `/etc/iperfclientserver.conf` file.
- Use `sudo systemctl stop iperfclient.service` to stop the client.

After a reboot the iperf client and server should automatically start exchanging information. Note that a small delay has been added to ensure that the wlan0 interface is up.

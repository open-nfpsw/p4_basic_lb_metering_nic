echo '======================================================================== '
echo      Starting Test for P4 Basic Loadbalancing and Metering - Source 1
echo '======================================================================== '
echo ' '

echo 'Sending traffic on ' $1' at 100kbps:'
echo 'Press Ctrl+C to stop test'
tcpreplay -q -K --mbps=0.1 -l0 -i $1 udp_traffic.pcap


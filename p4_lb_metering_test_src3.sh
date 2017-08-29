echo '======================================================================== '
echo      Starting Test for P4 Basic Loadbalacning and Metering - Source 3
echo '======================================================================== '
echo ' '

echo 'Sending traffic on ' $1' at 2mbps:'
echo 'Press Ctrl+C to stop test'
tcpreplay -q -K --mbps=2 -l0 -i $1 udp_traffic.pcap



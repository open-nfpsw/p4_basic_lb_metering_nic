echo '======================================================================== '
echo      Starting Test for P4 Basic Loadbalacning and Metering - Source 2
echo '======================================================================== '
echo ' '

echo 'Sending traffic on ' $1' at 400kbps:'
echo 'Press Ctrl+C to stop test'
tcpreplay -q -K --mbps=0.4 -l0 -i $1 udp_traffic.pcap


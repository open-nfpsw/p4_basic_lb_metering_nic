echo '======================================================================== '
echo      Starting Test for P4 Basic Loadbalacning and Metering - Source 4
echo '======================================================================== '
echo ' '

echo 'Sending traffic on ' $1' at top speed:'
echo 'Press Ctrl+C to stop test'
tcpreplay -q -K --topspeed -l0 -i $1 udp_traffic.pcap

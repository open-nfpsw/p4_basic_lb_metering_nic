# The Basic P4 NFP NIC

This basic NIC lab is the first step and the building block for the more advanced P4 labs. Here we will create a simple NFP NIC implementation in Programmer Studio with P4, and touch on more advanced actions such as metering and load balancing.

The final solution to the lab is also provided for reference:
- p4lab1_lb_metering.p4
- p4rules_complete.p4cfg

# Prerequisites

1. An installation of Netronome's Programmer Studio P4 Integrated Development Environment (available from [link](http://open-nfp.org)).
2. Access to a Linux server having a Netronome Agilio SmartNIC installed with its supporting board support utilities.

# Getting Started 

1. Download the source code.
2. Follow the instructions in the workbook.

# ICONICS: P4 Loadbalancer and Metering 

The final solution of the lab is also available as an ICONICS package for easy installation

# Installing and Testing P4 Basic Loadbalancer and Metering with ICONICS:

1.  Follow instructions on http://iconicsp4.cloudapp.net/ to install the NFP SDK RTE, setup access to the ICONICS repository and identifying your SmartNIC

    To install the P4 basic loadbalancer and metering application:
      yum install nfp-sdk6-p4-config-<smartnic>-p4_basic_lb_metering-<version>.noarch
      
    List all the available packages in the repo:
      repoquery -qa --repoid=iconics

2.  The test scripts will be installed to:
      /opt/nfp_pif/etc/smartnic-configs/<smartnic>-p4_basic_lb_metering/

      If the Traditional NIC that is being used to send the traffic is located on a different machine udp_traffic.udp and p4_lb_metering_test_src.sh needs to be copied to that machine
      
3.  Wait (around 2 minutes) for firmware to load onto the SmartNIC:
      Use ifconfig to see when VFs have loaded before trying to run tests or look in /var/log/nfp-sdk6-rte.log

4.  Run the test script 
      Run p4_lb_metering_test_src_x.sh numbered 1 to 4 on the host on which the SmartNIC is installed
      Run p4_lb_metering_test_host_x.sh <port> on the machine on which the traditional NIC is installed, for example:
         ./p4_lb_metering_test_host_1.sh p2p1

5.  Setup for port_to_vf:
Connect p0 of the SmartNIC to a port on a Traditional NIC.
The Tradtional NIC can be located on the same host or a separate machine and will be for inputting traffic to he Smart NIC.

  The test scripts will do the following:
    - p4_lb_metering_test_src_1.sh: Start continuously send packets from <port1> to p0 at speed of 100kpbs packets per second
    - p4_lb_metering_test_src_2.sh: Start continuously send packets from <port1> to p0 at speed of 400kpbs packets per second
    - p4_lb_metering_test_src_3.sh: Start continuously send packets from <port1> to p0 at speed of 2mpbs packets per second
    - p4_lb_metering_test_src_4.sh: Start continuously send packets from <port1> to p0 at top speed the configuration can support
    
  On the host the following will be observed
    - First test: traffic of ~25kpbs should be observed on each VF
    - Second test: traffic of ~100kpbs should be observed on each VF
    - Third test: On VF's 0,1,2 the traffic should be limited to ~200kbps while the traffic on VF 3 should be unlimited at ~500kbps
    - Fourth test: On VF's 0,1,2 the traffic should be limited to ~200kbps while the traffic on VF 3 should be limited to ~800kpbs

/*
 * Copyright (C) 2016, Netronome Systems, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 *
 */

header_type ethernet_t {
  fields {
    dstAddr   : 48;
    srcAddr   : 48;
    etherType : 16;
  }
}

header ethernet_t ethernet;

parser parse_ethernet {
  extract(ethernet);
  return ingress;
}

parser start {
  return parse_ethernet;
}

action act_send_to_port(port) {
  modify_field(standard_metadata.egress_spec, port);
}

action act_drop() {
  drop();
}

table tbl_forward {
  reads {
    standard_metadata.ingress_port : exact;
  }
  actions {
    act_send_to_port;
    act_drop;
  }
}

control ingress {
  apply(tbl_forward);
}

control egress {
}

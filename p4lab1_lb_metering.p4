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

field_list lb_header_list {
  ethernet.srcAddr;
  ethernet.dstAddr;
}

field_list_calculation lb_hash {
  input {
    lb_header_list;
  }
  algorithm : crc16;
  output_width : 16;
}

header_type extended_metadata_t {
  fields {
    hash : 2;
    meter_color : 2;
  }
}
metadata extended_metadata_t extended_metadata;

@pragma netro meter_drop_red
meter vf_meters {
  type : bytes;
  result : extended_metadata.meter_color;
  instance_count : 4;
}

action act_meter(meter_idx) {
  execute_meter(vf_meters, meter_idx, extended_metadata.meter_color);
  // Implicit drop when metered to red
}

action act_calc_hash() {
  modify_field_with_hash_based_offset(extended_metadata.hash, 0, lb_hash, 4);
}

action act_send_to_port(port)
{
  modify_field(standard_metadata.egress_spec, port);
}

action act_drop()
{
  drop();
}

table tbl_forward {
  reads {
    standard_metadata.ingress_port : exact;
    extended_metadata.hash : exact;
  }
  actions {
    act_send_to_port;
    act_drop;
  }
}

table tbl_lb_calc {
  actions {
    act_calc_hash;
  }
}

table tbl_egress_meter {
  reads {
    standard_metadata.egress_port : exact;
  }
  actions {
    act_meter;
  }
}

control ingress {
  apply(tbl_lb_calc);
  apply(tbl_forward);
}

control egress {
  apply(tbl_egress_meter);
}

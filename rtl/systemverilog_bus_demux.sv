////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// This file is placed into the Public Domain, for any use, without warranty, //
// 2012 by Iztok Jeras                                                        //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

import package_bus::*;
import package_str::*;

module systemverilog_bus_demux (
  // system signals
  input  logic        clk,
  input  logic        rst,
  // output stream
  input  logic        str_vld,
  input  logic  [7:0] str_bus,
  output logic        str_rdy,
  // input bus
  output logic        bus_vld,  // valid (chip select)
  output logic [31:0] bus_adr,  // address
  output logic [31:0] bus_dat,  // data
  input  logic        bus_rdy   // ready (acknowledge)
);

logic       bus_trn;
logic       str_trn;

logic [2:0] pkt_cnt;
t_bus       pkt_bus;
t_str       pkt_str;
logic       pkt_vld;

assign str_trn = str_vld & str_rdy;

assign str_ack = 1;

always @ (posedge clk, posedge rst)
if (rst)  pkt_cnt <= 3'd0;
else      pkt_cnt <= pkt_cnt + 3'd1;

always @ (posedge clk, posedge rst)
if (rst)  pkt_vld <= 1'b0;
else      pkt_vld <= bus_trn | pkt_vld;

always @ (posedge clk)
pkt_str [pkt_cnt] <= str_bus;

assign pkt_bus = pkt_str;

always @ (posedge clk)
begin
  bus_adr <= pkt_bus.adr;
  bus_dat <= pkt_bus.dat;
end

always @ (posedge clk, posedge rst)
if (rst)  bus_vld <= 1'b0;
else      bus_vld <= bus_trn | pkt_vld;

assign bus_trn = bus_vld & bus_rdy;

endmodule : systemverilog_bus_demux
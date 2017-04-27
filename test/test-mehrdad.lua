package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"

require "functions"


local sendport = "0";
local rcvport = "0";
local srcip = "192.168.0.1";
local dstip = "192.168.0.2";
local dstip_max = "${DST_IP_MAX}";
local netmask = "/24";
local src_mac = "${SRC_MAC}";
local dst_mac = "${DST_MAC}";
local rate = 100;
local send_for_secs = 300; --5mins
local log_file = "pktgen_5mins."..os.time()..".log";

--pktgen.set_ipaddr(sendport, "dst", dstip);
--pktgen.set_ipaddr(sendport, "src", srcip..netmask);
--pktgen.set_mac(sendport, dst_mac);
pktgen.set(sendport, "rate", rate);

pktgen.range(sendport, "off");
pktgen.set_proto(sendport..","..rcvport, "udp")
--pktgen.page("range");

--pktgen.dst_mac("all", dst_mac);
--pktgen.src_mac("all", src_mac);

---pktgen.dst_ip("all", "start", dstip);
--pktgen.dst_ip("all", "inc", "0.0.0.1");
--pktgen.dst_ip("all", "min", dstip);
--pktgen.dst_ip("all", "max", dstip_max);

--pktgen.src_ip("all", "start", srcip);
--pktgen.src_ip("all", "inc", "0.0.0.0");
--pktgen.src_ip("all", "min", srcip);
--pktgen.src_ip("all", "max", srcip);

local pktSize = tonumber(pktgen.input("Size of packets to send (64-1518B): "));
if pktSize == nil then
    pktSize = 64;
end
pktgen.set(sendport, "size", pktSize);

printf("\n*** Sending %dB packets for %d seconds ***\n", pktSize, send_for_secs);
pktgen.start(sendport);
local start_time = os.time();

-- I don't use just sleep(send_for_secs) because it blocks Pktgen's output
-- refreshing. Instead let's check the time on start and poll it until
-- the difference time_now - start_time reaches sends_for_secs.
while os.difftime(os.time(), start_time) < send_for_secs do
    sleep(1);
end
pktgen.stop(sendport);

-- Displaying results immediately shows 0 pkts, so let's wait a bit
sleep(5);






local stats = pktgen.portStats(sendport..","..rcvport, "port");
local sentpkts = stats[tonumber(sendport)].opackets;
local rcvdpkts = stats[tonumber(rcvport)].ipackets;

printf("\n*** RESULT:\tFinished in\t\t%d seconds\n", send_for_secs);
printf("\t\tsent %d pkts\t%.4f Mpkts/sec\n", sentpkts,
                                            (sentpkts/1000000)/send_for_secs);
printf("\t\trcvd %d pkts\t%.4f Mpkts/sec\n", rcvdpkts,
                                            (rcvdpkts/1000000)/send_for_secs);
printf("\t\tdeltapkts(TX - RX):\t%d pkts\n***\n", sentpkts-rcvdpkts);

printf("\nWriting to file %s\n", log_file);
write_stats_to_file(log_file, sendport, rcvport, send_for_secs);
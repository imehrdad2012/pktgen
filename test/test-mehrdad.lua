package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"

require "functions"


local log_file = "/home/vagrant/pktgenpktgen_5mins.log";

printf("Pktgen Authors : %s\n", pktgen.info.Pktgen_Authors);
printf("\nHello World!!!!\n");

local sendport = "0";
local rcvport = "0";

delay = 400

local start_time = os.time();

for i=100, 1500, 200
do
    pktgen.set("all", "size", i);
    pktgen.start("all");
    pktgen.delay(delay);
    pktgen.stop("all");
end

local send_for_secs = os.difftime(os.time(), start_time);


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
function write_stats_to_file(log_file, sendport, rcvport, time)
    local file = io.open(log_file, "w");
    local stats = pktgen.portStats(sendport..","..rcvport, "port");
    local sentpkts = stats[tonumber(sendport)].opackets;
    local rcvdpkts = stats[tonumber(rcvport)].ipackets;

    file:write(string.format("\n*** RESULT:\tFinished in\t\t%d seconds\n", time));
    file:write(string.format("\t\tsent %d pkts\t%.4f Mpkts/sec\n", sentpkts, (sentpkts/1000000)/time));
    file:write(string.format("\t\trcvd %d pkts\t%.4f Mpkts/sec\n", rcvdpkts, (rcvdpkts/1000000)/time));
    file:write(string.format("\t\tdeltapkts(TX - RX):\t%d pkts\n***\n", sentpkts-rcvdpkts));

    file:write(string.format("Pktgen-DPDK port %d dump:", sendport), "\n\n");
    -- file:write(serialize("linkState", pktgen.linkState(sendport)));
    -- file:write(serialize("isSending", pktgen.isSending(sendport)));
    file:write(serialize("portSizes", pktgen.portSizes(sendport)));
    file:write(serialize("pktStats", pktgen.pktStats(sendport)));
    file:write(serialize("portRates", pktgen.portStats(sendport, "rate")));
    file:write(serialize("portStats", pktgen.portStats(sendport, "port")));

    file:close();
end


function os_sleep(n)
  os.execute("sleep " .. tonumber(n))
end
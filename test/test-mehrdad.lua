package.path = package.path ..";?.lua;test/?.lua;app/?.lua;"

delay = 4000

for i=100, 1500, 200
do
    pktgen.set("all", "size", i);
    pktgen.start("all");
    pktgen.delay(delay);
    pktgen.stop("all");
end
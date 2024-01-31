1. => Recreer la configuration de la partie d'avant: Bridge, adresse ip des router, Vxlan

do sh ip rout => Affiche les routes pour une ip
do sh bgp summary -> Affiche le sommaire bgp
do sh bgp l2vpm evp -> Affiche le type de route, et la donnée associée. Type 2 => Adresse mac, type 3: Adresse ip
ifonfig eth1 => Confirm host address mac received by router
We can check that all routers have discovered newly booted up host
Check les adresses mac et le vxlan sur wireshark

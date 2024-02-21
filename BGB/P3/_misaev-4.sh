#!/bin/bash

# Début du script, indique que le script doit être exécuté avec Bash.
/etc/init.d/frr start
# Création d'un pont réseau nommé br0.
ip link add br0 type bridge
# Activation du pont réseau br0.
ip link set dev br0 up
# Ajout d'une interface VXLAN nommée vxlan10 avec l'identifiant 10 et le port de destination 4789.
ip link add vxlan10 type vxlan id 10 dstport 4789
# Activation de l'interface vxlan10.
ip link set vxlan10 up
# Attribution de vxlan10 au pont br0.
ip link set vxlan10 master br0
# Attribution de l'interface eth0 au pont br0.
ip link set eth0 master br0

# Entrez dans vtysh pour configurer FRR.
vtysh << EOT
conf t
# Désactiver le routage IPv6.
no ipv6 forwarding
interface eth2
# Attribuer une adresse IP à l'interface eth2 et définir son appartenance à la zone OSPF 0.
 ip address 10.1.1.10/30
 ip ospf area 0
!
interface lo
# Attribuer une adresse IP à l'interface de loopback et définir son appartenance à la zone OSPF 0.
 ip address 1.1.1.4/32
 ip ospf area 0
!
router bgp 1
# Configuration du voisin BGP avec l'adresse 1.1.1.1 et le même AS 1.
 neighbor 1.1.1.1 remote-as 1
# Définir l'interface de loopback comme source pour les mises à jour BGP.
 neighbor 1.1.1.1 update-source lo
 !
 address-family l2vpn evpn
  # Activer le voisin BGP pour la famille d'adresses L2VPN EVPN.
  neighbor 1.1.1.1 activate
  # Annoncer tous les VNI (Virtual Network Identifier).
  advertise-all-vni
 exit-address-family
!
router ospf
# Sortie de la configuration OSPF, pas d'autres commandes n'ont été fournies.
end
# Enregistrer la configuration dans la configuration permanente de FRR.
write
EOT

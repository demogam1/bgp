#!/bin/bash

# Ce script configure les interfaces réseau et les protocoles de routage sur un routeur.
/etc/init.d/frr start
# Entrez dans vtysh pour configurer FRR.
vtysh << EOT
config t
# Désactiver le routage IPv6.
no ipv6 forwarding

# Configurer l'interface eth0 avec l'adresse IP spécifiée.
interface eth0
 ip address 10.1.1.1/30
!

# Configurer l'interface eth1 avec l'adresse IP spécifiée.
interface eth1
 ip address 10.1.1.5/30
!

# Configurer l'interface eth2 avec l'adresse IP spécifiée.
interface eth2
 ip address 10.1.1.9/30
!

# Configurer l'interface de loopback avec l'adresse IP spécifiée.
interface lo
 ip address 1.1.1.1/32
!

# Configurer le protocole de routage BGP avec l'AS spécifié.
router bgp 1
 # Créer et configurer un groupe de pairs iBGP.
 neighbor ibgp peer-group
 neighbor ibgp remote-as 1
 neighbor ibgp update-source lo
 # Configurer l'écoute BGP sur une plage d'adresses pour le groupe de pairs iBGP.
 bgp listen range 1.1.1.0/24 peer-group ibgp
!
 # Activer la famille d'adresses L2VPN EVPN pour le groupe de pairs iBGP.
 address-family l2vpn evpn
  neighbor ibgp activate
  # Déclarer les voisins iBGP comme clients de réflecteur de routes.
  neighbor ibgp route-reflector-client
 exit-address-family
!

# Configurer le protocole de routage OSPF pour annoncer tous les réseaux.
router ospf
 network 0.0.0.0/0 area 0
!

# Configuration de la ligne vty (accès au terminal virtuel).
line vty
!
EOT

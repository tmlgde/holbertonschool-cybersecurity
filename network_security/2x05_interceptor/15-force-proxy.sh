#!/bin/bash
#!/bin/bash
sudo nft insert rule inet filter forward oifname "enp0s3" ip saddr 10.200.0.0/24 tcp dport 80 drop && sudo nft insert rule inet filter forward oifname "enp0s3" ip saddr 10.200.0.0/24 tcp dport 443 drop && sudo nft add rule inet filter output oifname "enp0s3" tcp dport { 80, 443 } accept

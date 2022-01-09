1. {"msg": "Missing sudo password"}
ansible-playbook --ask-become-pass
<username> ALL=NOPASSWD: ALL

2. Timeout
nano /usr/lib/systemd/system/elasticsearch.service
TimeoutStartSec=500

3. Check status
curl {ip_address}:9200

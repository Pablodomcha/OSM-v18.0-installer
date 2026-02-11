#!/bin/bash
kubectl -n osm exec -it lcm-65474b445d-shffn -- python3 -c "import socket; s = socket.socket(); s.settimeout(5); print('CONNECTED' if s.connect_ex(('10.0.2.6', 16443)) == 0 else 'FAILED')"

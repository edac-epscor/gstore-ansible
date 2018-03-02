#!/bin/bash
cd /opt/modwsgi/gstore_v3_env
source bin/activate
bin/pcreate -s alchemy gstore_v3
sed -i -e "s/'pyramid'/'pyramid==1.5.2'/g" /opt/modwsgi/gstore_v3_env/gstore_v3/setup.py
sed -i -e "s/'pyramid_debugtoolbar'/'pyramid_debugtoolbar==2.3'/g" /opt/modwsgi/gstore_v3_env/gstore_v3/setup.py
cd gstore_v3
../bin/python setup.py develop


#!/bin/bash

mount -t efs ${efs_id} /var/www/vhosts/${system_name}

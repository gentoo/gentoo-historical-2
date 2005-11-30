#!/bin/bash
# $Header: /var/cvsroot/gentoo-x86/www-servers/orion/files/2.0/stop_orion.sh,v 1.1.1.1 2005/11/30 09:46:47 chriswhite Exp $
ps auxww | grep orion.jar | awk '{print $2}' | xargs kill &> /dev/null

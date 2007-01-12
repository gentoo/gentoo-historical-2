# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/files/java-config-2.profiled.sh,v 1.1 2007/01/12 17:57:48 betelgeuse Exp $

# If we have a current-user-vm (and aren't root)... set it to JAVA_HOME
gentoo_user_vm="${HOME}/.gentoo/java-config-2/current-user-vm"
gentoo_system_vm="/etc/java-config-2/current-system-vm"

if [[ ${UID} != 0 && -L ${gentoo_user_vm} ]]; then
	export JAVA_HOME=${gentoo_user_vm}
# Otherwise set to the current system vm
elif [[ -L /etc/java-config-2/current-system-vm ]]; then
	export JAVA_HOME=${gentoo_system_vm}
fi
export JDK_HOME=${JAVA_HOME}
export JAVAC=${JDK_HOME}/bin/javac
unset gentoo_user_vm gentoo_system_vm

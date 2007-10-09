# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/java-virtuals-2.eclass,v 1.3 2007/10/09 09:57:25 ali_bush Exp $

# Original Author: Alistair John Bush <ali_bush@gentoo.org>
# Purpose: 	To provide a default (and only) src_install function
# 			for ebuilds in the java-virtuals category.

inherit java-utils-2

EXPORT_FUNCTIONS src_install

java-virtuals-2_src_install() {
	java-virtuals-2_do_write
}

# ------------------------------------------------------------------------------
# @internal-function java-pkg_do_virtuals_write
#
# Writes the virtual env file out to disk.
#
# ------------------------------------------------------------------------------
java-virtuals-2_do_write() {
	java-pkg_init_paths_

	dodir "${JAVA_PKG_VIRTUALS_PATH}"
	{
		if [[ -n "${JAVA_VIRTUAL_PROVIDES}" ]]; then
			echo "PROVIDERS=\"${JAVA_VIRTUAL_PROVIDES}\""
		fi

		if [[ -n "${JAVA_VIRTUAL_VM}" ]]; then
			echo "VM=\"${JAVA_VIRTUAL_VM}\""
		fi

		if [[ -n "${JAVA_VIRTUAL_VM_CLASSPATH}" ]]; then
			echo "VM_CLASSPATH=\"${JAVA_VIRTUAL_VM_CLASSPATH}\""
		fi
	} > "${JAVA_PKG_VIRTUAL_PROVIDER}"
}

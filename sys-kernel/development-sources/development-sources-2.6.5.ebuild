# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/development-sources/development-sources-2.6.5.ebuild,v 1.13 2004/06/24 22:56:05 agriffis Exp $

IUSE="ultra1"

K_NOUSENAME="yes"
ETYPE="sources"
SPARC_URI="mirror://gentoo/patches-2.6.5-sparc.tar.bz2"
S390_URI="mirror://gentoo/patches-2.6.5-s390.tar.bz2"
inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Full sources for the vanilla 2.6 kernel tree"
HOMEPAGE="http://www.kernel.org/"
SRC_URI="${KERNEL_URI} ${ARCH_URI}"
UNIPATCH_LIST="${ARCH_PATCH}"

use ultra1 || UNIPATCH_EXCLUDE="99_U1-hme-lockup"

KEYWORDS="x86 ~sparc ~alpha ~ia64 ppc arm s390 ~amd64"

pkg_postinst() {
	postinst_sources

	if [ "${ARCH}" = "sparc" ]; then
		if [ x"`cat /proc/openprom/name 2>/dev/null`" \
			 = x"'SUNW,Ultra-1'" ]; then
			einfo "For users with an Enterprise model Ultra 1 using the HME"
			einfo "network interface, please emerge the kernel using the"
			einfo "following command: USE=ultra1 emerge ${PN}"
		fi
	fi

	if [ "${ARCH}" = "ppc" ]; then
		ewarn "BEWARE"
		ewarn "If you want power management make sure you have SERIAL_PMACZILOG"		ewarn "set to no."
		ewarn "You can find the voice in Device Drivers -> Character Devices ->"
		ewarn "Serial Drivers -> PowerMac z80c30 ESCC Support"
		ewarn "report bugs to lu_zero@gentoo.org"
	fi
}

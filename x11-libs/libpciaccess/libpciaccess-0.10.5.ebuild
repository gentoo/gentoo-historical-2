# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libpciaccess/libpciaccess-0.10.5.ebuild,v 1.1 2008/11/07 11:34:21 remi Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Library providing generic access to the PCI bus and devices"
LICENSE="MIT"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="minimal"

DEPEND="!<x11-base/xorg-server-1.5"

CONFIGURE_OPTIONS="--with-pciids-path=/usr/share/misc"

src_install() {
	x-modular_src_install
	if ! use minimal; then
		dobin src/.libs/scanpci || die
	fi
}

# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foomatic/foomatic-3.0.0.ebuild,v 1.5 2004/06/25 00:38:21 agriffis Exp $

DESCRIPTION="The Foomatic printing meta package"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64"
IUSE=""

DEPEND="net-print/foomatic-filters
	net-print/foomatic-db-engine
	net-print/foomatic-db"

pkg_postinst () {
	einfo
	einfo "If printing does not work, try to install the latest version of"
	einfo "gimp-print / hpijs or regerate your ppd file."
	einfo
}

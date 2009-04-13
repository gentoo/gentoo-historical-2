# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/pms/pms-2.ebuild,v 1.1 2009/04/13 08:45:32 fauli Exp $

EAPI=2

DESCRIPTION="Gentoo Package Manager Specification (draft)"
HOMEPAGE="http://www.gentoo.org/proj/en/qa/pms.xml"
SRC_URI="http://dev.gentoo.org/~gentoofan23/pms/eapi-2-approved/pms.pdf -> pms-${PV}.pdf"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~sparc"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	:
}

src_install() {
	dodoc "${DISTDIR}"/pms-2.pdf || die
}

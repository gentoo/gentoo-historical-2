# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/gnucap/gnucap-0.33.ebuild,v 1.6 2004/06/24 22:01:38 agriffis Exp $

DESCRIPTION="GNUCap is the GNU Circuit Analysis Package"
SRC_URI="http://geda.seul.org/dist/gnucap-${PV}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gnucap"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	insinto /usr/bin
	doins src/O/gnucap
	fperms 755 /usr/bin/gnucap

	dodoc doc/COPYING doc/acs-tutorial doc/whatisit
}

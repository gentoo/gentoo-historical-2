# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/snarf/snarf-7.0-r2.ebuild,v 1.12 2004/07/01 21:57:01 squinky86 Exp $

inherit eutils

S=${WORKDIR}/${P}
IUSE=""
DESCRIPTION="Small and fast command line resource grabber with support for http, gopher, finger, and ftp protocols."
SRC_URI="http://www.xach.com/snarf/${P}.tar.gz"
HOMEPAGE="http://www.xach.com/snarf/"
KEYWORDS="x86 alpha sparc"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/snarf-basename-patch.diff
	epatch ${FILESDIR}/snarf-unlink-empty.diff
}

src_install() {
	dobin snarf
	doman snarf.1
	dodoc COPYING ChangeLog README TODO
}

pkg_postinst() {
	einfo 'To use snarf with portage, try these settings in your make.conf'
	einfo
	einfo '	FETCHCOMMAND="/usr/bin/snarf -b \${URI} \${DISTDIR}/\${FILE}"'
	einfo '	RESUMECOMMAND="/usr/bin/snarf -rb \${URI} \${DISTDIR}/\${FILE}"'
}

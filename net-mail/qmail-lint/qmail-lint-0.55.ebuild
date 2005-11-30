# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qmail-lint/qmail-lint-0.55.ebuild,v 1.1.1.1 2005/11/30 10:03:11 chriswhite Exp $
DESCRIPTION="qmail-lint checks your qmail configuration for common problems"
HOMEPAGE="http://www.qmail.org/"
SRC_URI="mirror://qmail/${P}"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
# Should run on all platforms without issue
IUSE=""
DEPEND=""
RDEPEND="mail-mta/qmail dev-lang/perl"
S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${P} ${PN}
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dobin ${PN}
}

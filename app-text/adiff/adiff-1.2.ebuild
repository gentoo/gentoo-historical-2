# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/adiff/adiff-1.2.ebuild,v 1.1 2005/08/15 16:45:56 agriffis Exp $

DESCRIPTION="wordwise diff"
HOMEPAGE="http://gentoo.org/~agriffis/adiff/"
SRC_URI="${HOMEPAGE}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	sys-apps/diffutils"

S=${WORKDIR}

src_compile() {
	pod2man --release=${PV} --center="${HOMEPAGE}" \
		--date="2005-08-15" ${DISTDIR}/${P} ${PN}.1 || die
}

src_install() {
	newbin ${DISTDIR}/${P} ${PN}
	doman ${PN}.1
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/buddy/buddy-2.4.ebuild,v 1.5 2010/01/02 18:06:57 fauli Exp $

inherit eutils

DESCRIPTION="BuDDY - A Binary Decision Diagram Package"
HOMEPAGE="http://sourceforge.net/projects/buddy"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	dodoc ChangeLog NEWS AUTHORS README doc/*.txt || \
		die "failed to install docs"

	insinto /usr/share/doc/${P}/ps
	doins doc/*.ps || die "failed to install postscripts files"

	insinto /usr/share/${PN}/examples
	cd examples
	for example in *; do
		tar -czf ${example}.tar.gz ${example}
		doins ${example}.tar.gz
	done
}

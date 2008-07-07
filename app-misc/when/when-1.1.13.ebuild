# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/when/when-1.1.13.ebuild,v 1.1 2008/07/07 16:07:25 armin76 Exp $

DESCRIPTION="Extremely simple personal calendar program aimed at the Unix geek who wants something minimalistic"
HOMEPAGE="http://www.lightandmatter.com/when/when.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

S=${WORKDIR}/when_dist

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix path for tests
	sed -i 's,^	when,	./when,' Makefile
}

src_compile() {
	return
}

src_test() {
	# The when command requires these files, or attempts to run setup function.
	mkdir "${HOME}"/.when
	touch "${HOME}"/.when/{calendar,preferences}
	emake test || die "emake test failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"
	doman ${PN}.1 || die "doman failed"
	dodoc README
}

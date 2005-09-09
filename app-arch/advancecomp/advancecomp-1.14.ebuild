# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/advancecomp/advancecomp-1.14.ebuild,v 1.5 2005/09/09 14:27:48 agriffis Exp $

inherit eutils

DESCRIPTION="Recompress ZIP, PNG and MNG using deflate 7-Zip, considerably improving compression"
HOMEPAGE="http://advancemame.sourceforge.net/comp-readme.html"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ~x86"
IUSE="png mng"

DEPEND="sys-libs/zlib app-arch/bzip2"

src_unpack() {
	unpack ${A}

	# bzip2 support wont compile, here's a quick patch.
	cd ${S}; epatch ${FILESDIR}/${PN}-1.13-bzip2-compile-plz-k-thx.diff

	epatch ${FILESDIR}/${PN}-1.13-64bit.diff
}

src_compile() {
	econf --enable-bzip2 || die
	emake || die
}

src_install() {
	dobin advdef advzip

	use png && {
		dobin advpng
		doman doc/advpng.1
	}

	use mng && {
		dobin advmng
		doman doc/advmng.1
	}

	dodoc HISTORY AUTHORS INSTALL README
	doman doc/advdef.1 doc/advzip.1
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libhtmlparse/libhtmlparse-0.1.13.ebuild,v 1.4 2014/03/10 10:47:39 ssuominen Exp $

DESCRIPTION="HTML parsing library. It takes HTML tags, text, and calls callbacks for each type of token"
HOMEPAGE="http://msalem.translator.cx/libhtmlparse.html"
SRC_URI="http://msalem.translator.cx/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	cd "${WORKDIR}"
	# for some reason, we get a "this does not look like a tar archive" error
	# but the following works... go figure.
	gunzip -c "${DISTDIR}"/${P}.tar.gz > ${P}.tar
	tar xf ${P}.tar || die "failed to unpack ${P}.tar"
	rm ${P}.tar
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS INSTALL ChangeLog NEWS README TODO
}

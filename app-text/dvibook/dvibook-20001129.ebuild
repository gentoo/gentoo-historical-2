# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvibook/dvibook-20001129.ebuild,v 1.7 2006/02/11 15:17:42 joshuabaergen Exp $

inherit eutils

DESCRIPTION="DVI file utilities: dvibook, dviconcat, dvitodvi, and dviselect."
HOMEPAGE="http://www.ctan.org/tex-archive/dviware/dvibook/"
# Taken from: ftp://tug.ctan.org/tex-archive/dviware/${PN}.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="dvibook"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

IUSE=""
DEPEND="|| ( ( x11-misc/imake
				x11-misc/gccmakedep
				app-text/rman )
			virtual/x11 )"
RDEPEND=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}.patch
}

src_compile() {
	xmkmf -a || die "xmkmf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install install.man || die

	dodoc README
}

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xfe/xfe-0.72.ebuild,v 1.5 2005/02/19 08:06:50 corsair Exp $

inherit eutils

DESCRIPTION="MS-Explorer like file manager for X"
HOMEPAGE="http://roland65.free.fr/xfe/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc amd64 ~ppc ppc64"
IUSE="nls"

# fox-1.0.x, fox-1.1.x and fox-1.3.x are incompatible.
DEPEND="=x11-libs/fox-1.2*"

src_unpack()
{
	unpack ${A}
	cd ${S}

	# Fix #62428. Note: this 0.70 related bug is STILL present in 0.72...
	epatch ${FILESDIR}/xfe-0.70-file-association.patch
}

src_compile()
{
	econf `use_enable nls` || die
	emake || die
}

src_install()
{
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS FAQ README TODO NEWS
}

pkg_postinst()
{
	einfo
	einfo 	"Please delete your old Xfe registry files"
	einfo 	" (~/.foxrc/Xfe ~/.foxrc/Xfv and ~/.foxrc/Xfq)"
	einfo	"before using this XFE 0.72 release"
	einfo
}

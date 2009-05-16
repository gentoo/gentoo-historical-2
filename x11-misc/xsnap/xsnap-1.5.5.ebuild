# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xsnap/xsnap-1.5.5.ebuild,v 1.1 2009/05/16 19:48:58 nelchael Exp $

DESCRIPTION="Program to interactively take a 'snapshot' of a region of the screen"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/Xutils/${P}.tar.bz2"
HOMEPAGE="ftp://ftp.ac-grenoble.fr/ge/Xutils/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	media-libs/libpng
	media-libs/jpeg"
DEPEND="${RDEPEND}
	x11-proto/xproto
	app-text/rman
	x11-misc/imake"

src_unpack() {

	unpack ${A}
	cd "${S}"

	sed -i -e 's,$(BINDIR),$(DESTDIR)/$(BINDIR),' "${S}/Imakefile"

}

src_compile() {

	xmkmf || die "xmkmf failed"
	make || die "make failed"

}

src_install() {

	make DESTDIR="${D}" install || die "make install failed"
	make DESTDIR="${D}" install.man || die "make install.man failed"
	dodoc README AUTHORS

}

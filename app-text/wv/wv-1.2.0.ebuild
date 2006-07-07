# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wv/wv-1.2.0.ebuild,v 1.2 2006/07/07 21:01:50 lu_zero Exp $

DESCRIPTION="Tool for conversion of MSWord doc and rtf files to something readable"
SRC_URI="mirror://sourceforge/wvware/${P}.tar.gz"
HOMEPAGE="http://wvware.sourceforge.net/"

IUSE="wmf"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=dev-libs/glib-2
	>=gnome-extra/libgsf-1
	sys-libs/zlib
	media-libs/libpng
	dev-libs/libxml2
	wmf? ( >=media-libs/libwmf-0.2.2 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"


src_compile() {
	econf `use_with wmf libwmf` || die "./configure failed"

	emake || die "Compilation failed"
}

src_install () {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc README

	insinto /usr/include
	doins wvinternal.h

	rm -f ${D}/usr/share/man/man1/wvConvert.1
	dosym  /usr/share/man/man1/wvWare.1 /usr/share/man/man1/wvConvert.1
}

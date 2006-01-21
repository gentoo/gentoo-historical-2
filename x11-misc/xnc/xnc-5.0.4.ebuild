# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xnc/xnc-5.0.4.ebuild,v 1.9 2006/01/21 18:11:32 nelchael Exp $

DESCRIPTION="file manager for X Window system very similar to Norton Commander"
HOMEPAGE="http://xnc.dubna.su/"
SRC_URI="http://xnc.dubna.su/src-5/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~amd64"
IUSE="nls"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXext )
	virtual/x11 )
	media-libs/libpng
	media-libs/tiff
	media-libs/jpeg"
DEPEND="${RDEPEND}
	|| ( (
		x11-proto/xextproto
		x11-proto/xproto )
	virtual/x11 )"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		`use_enable nls` \
		|| die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog LICENSE README TODO
}

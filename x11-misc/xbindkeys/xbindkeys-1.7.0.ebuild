# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xbindkeys/xbindkeys-1.7.0.ebuild,v 1.7 2004/06/24 22:38:32 agriffis Exp $

IUSE="guile tcltk"

DESCRIPTION="Tool for launching commands on keystrokes"
SRC_URI="http://hocwp.free.fr/xbindkeys/${P}.tar.gz"
HOMEPAGE="http://hocwp.free.fr/xbindkeys/"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64 sparc"
SLOT="0"

DEPEND="virtual/x11
	guile? ( dev-util/guile )
	tcltk? ( dev-lang/tk )"

src_compile() {
	local myconf
	use tcltk || myconf="${myconf} --disable-tk"
	use guile || myconf="${myconf} --disable-guile"
	econf ${myconf} || die
	emake DESTDIR=${D} || die

}

src_install() {
	emake DESTDIR=${D} \
		BINDIR=/usr/bin install || die "Installation failed"

}


# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-kids/stickers/stickers-0.1.3-r1.ebuild,v 1.6 2005/06/10 13:21:54 dholm Exp $

DESCRIPTION="Stickers Book for small children"
HOMEPAGE="http://users.powernet.co.uk/kienzle/stickers/"
SRC_URI="http://users.powernet.co.uk/kienzle/stickers/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls"

DEPEND="virtual/x11
	media-libs/imlib
	=x11-libs/gtk+-1.2*
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	# gcc34 fix? (bug #72734)
	sed -i \
		-e '/ONTRACE/d' "${S}/rc.c" \
		|| die "sed failed"
}

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"

	./configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} || die "configure failed"
	emake || die "emake failed"
}

src_install () {
	make \
		prefix="${D}/usr" \
		infodir="${D}/usr/share/info" \
		mandir="${D}/usr/share/man" install \
		|| die "make install failed"
}

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/oxine/oxine-0.2.ebuild,v 1.11 2005/09/10 14:07:23 flameeyes Exp $

inherit eutils

DESCRIPTION="OSD frontend for xine"
HOMEPAGE="http://oxine.sourceforge.net/"
LICENSE="GPL-2"

DEPEND=">=media-libs/xine-lib-1_beta8
	lirc? ( app-misc/lirc )
	nls? ( sys-devel/gettext )
	dev-libs/popt
	virtual/x11"

IUSE="nls lirc"

SLOT="0"
KEYWORDS="~amd64 ppc x86"

SRC_URI="mirror://sourceforge/oxine/${P}.tar.gz"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-gcc34.patch
	epatch ${FILESDIR}/${P}-xtst.patch
}

src_compile() {

	local myconf
	use nls || myconf="${myconf} --disable-nls"
	use lirc || myconf="${myconf} --disable-lirc"

	econf ${myconf} || die
	emake || die
}

src_install() {

	make DESTDIR=${D} \
		docdir=/usr/share/doc/${PF} \
		docsdir=/usr/share/doc/${PF} \
		install || die

	dodoc AUTHORS ChangeLog NEWS README TODO
}

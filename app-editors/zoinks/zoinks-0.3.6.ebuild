# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/zoinks/zoinks-0.3.6.ebuild,v 1.1 2003/09/20 03:11:11 genone Exp $

DESCRIPTION="Zoinks is a programmer's text editor and development environment"
HOMEPAGE="http://zoinks.mikelockwood.com/"
SRC_URI="http://zoinks.mikelockwood.com/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls imlib"
DEPEND="nls? ( sys-devel/gettext )
	imlib? ( media-libs/imlib )
	x11-base/xfree"

src_compile() {
	local myconf
	myconf="${myconf} `use_enable nls`"
	myconf="${myconf} `use_with imlib`"
	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die
	dodoc README INSTALL COPYING AUTHORS NEWS ChangeLog
}


# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/zoinks/zoinks-0.3.8.ebuild,v 1.7 2004/10/05 12:19:44 pvdabeel Exp $

DESCRIPTION="programmer's text editor and development environment"
HOMEPAGE="http://zoinks.mikelockwood.com/"
SRC_URI="http://zoinks.mikelockwood.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="nls imlib"

DEPEND="nls? ( sys-devel/gettext )
	imlib? ( media-libs/imlib )
	virtual/x11"

src_compile() {
	econf \
		`use_enable nls` \
		`use_enable imlib` \
		|| die
	emake  || die
}

src_install() {
	einstall || die
	dodoc README INSTALL AUTHORS NEWS ChangeLog
}

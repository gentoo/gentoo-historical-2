# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ircii/ircii-20060725.ebuild,v 1.3 2007/03/19 13:35:27 gustavoz Exp $

IUSE="ipv6"

DESCRIPTION="ircII is an IRC and ICB client that runs under most UNIX platforms."
SRC_URI="ftp://ircii.warped.com/pub/ircII/${P}.tar.bz2"
HOMEPAGE="http://www.eterna.com.au/ircii/"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc-macos sparc x86"

src_compile() {
	econf $(use_enable ipv6) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc ChangeLog INSTALL NEWS README \
		doc/Copyright doc/crypto doc/VERSIONS doc/ctcp \
		|| die "dodoc failed"
}

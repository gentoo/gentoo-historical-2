# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lineakd/lineakd-0.9.0.ebuild,v 1.2 2007/06/03 21:01:14 drac Exp $

inherit multilib

MY_P=${P/.0/}

DESCRIPTION="Linux support for Easy Access and Internet Keyboards features X11 support"
HOMEPAGE="http://lineak.sourceforge.net"
SRC_URI="mirror://sourceforge/lineak/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug"

RDEPEND="x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-libs/libxkbfile
	x11-libs/libXt
	x11-proto/xextproto
	x11-proto/xproto"

S="${WORKDIR}"/${MY_P}

src_compile() {
	econf $(use_enable debug) --with-x
	emake || die "emake failed."
}

src_install () {
	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' lineakd/Makefile

	dodir /usr/share/man/man8

	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS README TODO
	keepdir /usr/$(get_libdir)/lineakd/plugins

	insinto /etc/lineak
	doins lineakd.conf.example
	doins lineakd.conf.kde.example
}

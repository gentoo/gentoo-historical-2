# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/loqui/loqui-0.4.4.ebuild,v 1.1 2005/10/29 01:36:10 swegener Exp $

DESCRIPTION="Loqui is a graphical IRC client for GNOME2 on UNIX like operating system."
SRC_URI="http://loqui.good-day.net/src/${P}.tar.gz"
HOMEPAGE="http://loqui.good-day.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.2.1
	>=x11-libs/gtk+-2.4
	>=net-libs/gnet-2.0.3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}

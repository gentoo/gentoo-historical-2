# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xpad/xpad-4.0.ebuild,v 1.5 2009/10/10 16:24:22 armin76 Exp $

EAPI=2

DESCRIPTION="A GTK+ 2.0 based 'post-it' note system."
HOMEPAGE="http://mterry.name/xpad"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.12:2"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.31
	dev-util/pkgconfig
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

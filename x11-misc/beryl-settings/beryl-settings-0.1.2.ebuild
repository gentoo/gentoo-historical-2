# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/beryl-settings/beryl-settings-0.1.2.ebuild,v 1.1 2006/11/15 04:00:20 tsunam Exp $

DESCRIPTION="Beryl Window Decorator Settings"
HOMEPAGE="http://beryl-project.org"
SRC_URI="http://releases.beryl-project.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
WANT_AUTOMAKE=1.9

DEPEND=">=x11-libs/gtk+-2.8.0
	=x11-wm/beryl-core-0.1.2"

src_compile() {
	glib-gettextize --copy --force || die
	intltoolize --automake --copy --force || die

	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

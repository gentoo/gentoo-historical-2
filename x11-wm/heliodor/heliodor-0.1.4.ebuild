# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/heliodor/heliodor-0.1.4.ebuild,v 1.2 2008/06/05 11:59:14 remi Exp $

inherit eutils

DESCRIPTION="Beryl Metacity Window Decorator"
HOMEPAGE="http://beryl-project.org"
SRC_URI="http://releases.beryl-project.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8.0
	>=x11-libs/libwnck-2.14.2
	>=gnome-base/gconf-2
	>=gnome-base/gnome-control-center-2.14
	>=x11-wm/metacity-2.16
	~x11-wm/beryl-core-${PV}"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/regexxer/regexxer-0.6.ebuild,v 1.1 2004/01/25 14:00:29 pyrania Exp $

DESCRIPTION="An interactive tool for performing search and replace operations"
HOMEPAGE="http://regexxer.sourceforge.net/"
SRC_URI="mirror://sourceforge/regexxer/${P}.tar.gz"

LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc"

RDEPEND=">=x11-libs/gtk+-2.2
	>=dev-libs/glib-2
	>=dev-libs/libsigc++-1.2
	>=dev-cpp/gtkmm-2.2.8
	>=dev-libs/libpcre-3.9-r2
	>=dev-cpp/gconfmm-2.0.1
	>=dev-cpp/gnome-vfsmm-1.3.5"

DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_compile() {
	econf || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	einstall || die "install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}

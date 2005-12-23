# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/porthole/porthole-0.5.0.ebuild,v 1.1 2005/12/23 04:40:34 fuzzyray Exp $

inherit distutils

DESCRIPTION="A GTK+-based frontend to Portage"
HOMEPAGE="http://porthole.sourceforge.net"
SRC_URI="mirror://sourceforge/porthole/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE="debug nls"
DEPEND=">=dev-lang/python-2.3
	>=sys-apps/portage-2.0.51-r3
	>=dev-python/pygtk-2.4.0
	>=dev-python/pyxml-0.8.4
	>=gnome-base/libglade-2.5.0
	nls? ( >=sys-devel/gettext-0.14 )"

RDEPEND="${DEPEND} debug? ( >=dev-python/pycrash-0.4_pre3 )"

src_install() {
	distutils_src_install
	chmod -R a+rX ${D}/usr/share/porthole
	dodoc TODO README NEWS AUTHORS COPYING MANIFEST
	keepdir /var/log/porthole
	fperms g+w /var/log/porthole
	# Compile localizations if necessary
	if use nls; then
		cd ${D}/usr/share/porthole
		./pocompile.sh
	fi
}

pkg_preinst() {
	chgrp portage ${IMAGE}/var/log/porthole
}

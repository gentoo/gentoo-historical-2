# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/porthole/porthole-0.6.0_rc2.ebuild,v 1.6 2009/05/24 04:19:12 arfrever Exp $

inherit eutils distutils

DESCRIPTION="A GTK+-based frontend to Portage"
HOMEPAGE="http://porthole.sourceforge.net"
SRC_URI="mirror://sourceforge/porthole/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

RDEPEND=">=dev-lang/python-2.3
	>=sys-apps/portage-2.0.51-r3
	>=dev-python/pygtk-2.4.0
	>=dev-python/pyxml-0.8.4
	>=gnome-base/libglade-2.5.0
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.14 )"

src_unpack() {
	# Change shebang line to /bin/bash since pocompile.sh is not a posix script
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PF}-pocompile.patch
}

src_install() {
	distutils_src_install
	chmod -R a+rX "${D}"/usr/share/porthole
	dodoc TODO README NEWS AUTHORS MANIFEST
	keepdir /var/log/porthole
	fperms g+w /var/log/porthole
	keepdir /var/db/porthole
	fperms g+w /var/db/porthole
	# Compile localizations if necessary
	if use nls ; then
		cd "${D}"/usr/share/porthole
		./pocompile.sh || die "pocompile.sh failed"
	fi
}

pkg_preinst() {
	chgrp portage "${D}"/var/log/porthole
	chgrp portage "${D}"/var/db/porthole
}

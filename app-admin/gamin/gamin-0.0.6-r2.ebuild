# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gamin/gamin-0.0.6-r2.ebuild,v 1.2 2004/08/24 17:29:56 azarah Exp $

inherit eutils

INOTIFY_VER="0.8.1"

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI="http://www.gnome.org/~veillard/gamin/sources/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=

DEPEND="virtual/libc
	>=dev-libs/glib-2.0
	!app-admin/fam"

PROVIDE="virtual/fam"

src_unpack() {
	unpack ${A}

	cd ${S}/server
	if [ -f "/usr/src/linux/include/linux/inotify.h" ]
	then
		cp /usr/src/linux/include/linux/inotify.h .
	elif [ -f "/usr/include/linux/inotify.h" ]
	then
		cp /usr/include/linux/inotify.h .
	else
		cp "${FILESDIR}/inotify-${INOTIFY_VER}.h" inotify.h
	fi

	# Include our inotify.h
	epatch ${FILESDIR}/${P}-inotify_h-include.patch
	# Select the backend at runtime
	epatch ${FILESDIR}/${P}-runtime-backend-select.patch
	# Sources is using wrong DEFINE to check if INotify should be enabled ...
	epatch ${FILESDIR}/${P}-actually-enable-inotify-support.patch
	# Only complain about failing to open inotify node if debug is enabled.
	epatch ${FILESDIR}/${P}-quiet-inotify-warning.patch
}

src_compile() {
	econf --enable-inotify \
		--enable-debug || die
	# Enable debug for testing the runtime backend patch

	# Currently not smp safe
	emake || die "emake failed"
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog Copyright README TODO
}

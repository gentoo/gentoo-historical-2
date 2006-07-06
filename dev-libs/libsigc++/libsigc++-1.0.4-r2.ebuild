# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsigc++/libsigc++-1.0.4-r2.ebuild,v 1.21 2006/07/06 01:01:42 vapier Exp $

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="http://libsigc.sourceforge.net/"
SRC_URI="http://download.sourceforge.net/libsigc/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1.0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sh sparc x86"
IUSE="debug"

DEPEND=""

src_compile() {
	use debug \
		&& myconf="--enable-debug=yes" \
		|| myconf="--enable-debug=no"
	econf ${myconf} || die

	# Fix sandbox violation when old libsig++ is already installed,
	# hopefully this will go away after the header location settles down
	# Comment out the remove old header directory line

	cp sigc++/Makefile sigc++/Makefile.orig
	sed -e 's:\(@if\):#\1:' \
		sigc++/Makefile.orig > sigc++/Makefile

	# This occurs in two places

	cp sigc++/config/Makefile sigc++/config/Makefile.orig
	sed -e 's:\(@if\):#\1:' \
		sigc++/config/Makefile.orig > sigc++/config/Makefile

	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README* INSTALL NEWS
}

pkg_postinst() {
	ewarn "To allow parallel installation of sig++-1.0 and sig++-1.2,"
	ewarn "the header files are now installed in a version specific"
	ewarn "subdirectory.  Be sure to unmerge any libsig++ versions"
	ewarn "< 1.0.4 that you may have previously installed."
}

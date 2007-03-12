# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/naim/naim-0.11.8.2.1.ebuild,v 1.3 2007/03/12 20:19:45 swegener Exp $


DESCRIPTION="An ncurses based AOL Instant Messenger"
HOMEPAGE="http://naim.n.ml.org"
SRC_URI="http://naim.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="debug screen"

# the tests dont work
RESTRICT=test

DEPEND=">=sys-libs/ncurses-5.2
		screen? ( app-misc/screen )"

src_unpack() {
	unpack ${A}

	# Alter makefile so firetalk-int.h is installed
	cd ${S}
	sed -i 's/include_HEADERS = firetalk.h/include_HEADERS = firetalk.h firetalk-int.h/' \
		libfiretalk/Makefile.am \
		libfiretalk/Makefile.in
}

src_compile() {
	# --enable-profile
	local myconf=""

	use debug && myconf="${myconf} --enable-debug"
	use screen && myconf="${myconf} --enable-detach"

	econf \
		--with-pkgdocdir=/usr/share/doc/${PF} \
		${myconf} \
		|| die "configure failed"

	# Use -j1, because naim doesn't compile with ${MAKEOPTS} > 1
	# see bug #139329
	emake -j1 || die "make failed"
}

src_install() {
	cd ${S}
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS FAQ BUGS README NEWS ChangeLog doc/*.hlp
}

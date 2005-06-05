# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxklavier/libxklavier-2.0.ebuild,v 1.6 2005/06/05 18:10:13 foser Exp $

inherit eutils

DESCRIPTION="High level XKB library"
HOMEPAGE="http://www.freedesktop.org/Software/LibXklavier"
SRC_URI="mirror://sourceforge/gswitchit/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc"
IUSE="doc"

RDEPEND="virtual/x11
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_unpack() {

	unpack ${A}

	cd ${S}
	# Do not error on warnings (for gcc4 support).  Patch from Fedora.
	epatch ${FILESDIR}/libxklavier-1.14-werror.patch
}

src_compile() {

	econf --with-xkb_base=/usr/$(get_libdir)/X11/xkb \
		$(use_enable doc doxygen) || die
	emake || die "emake failed"

}

src_install() {

	make install DESTDIR=${D} || die
	insinto /usr/share/libxklavier
	use sparc && doins "${FILESDIR}/sun.xml"
	dodoc AUTHORS CREDITS ChangeLog NEWS README

}

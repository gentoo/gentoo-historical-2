# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxklavier/libxklavier-2.0.ebuild,v 1.15 2005/11/06 22:47:41 dang Exp $

inherit eutils

DESCRIPTION="High level XKB library"
HOMEPAGE="http://www.freedesktop.org/Software/LibXklavier"
SRC_URI="mirror://sourceforge/gswitchit/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="doc"

RDEPEND="|| ( (
		x11-libs/libX11
		x11-libs/libxkbfile )
	virtual/x11 )
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	|| ( (
		x11-libs/libXt
		x11-proto/xproto )
	virtual/x11 )
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

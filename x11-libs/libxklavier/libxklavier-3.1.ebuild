# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxklavier/libxklavier-3.1.ebuild,v 1.7 2007/02/03 16:56:40 blubb Exp $

inherit eutils

DESCRIPTION="High level XKB library"
HOMEPAGE="http://www.freedesktop.org/Software/LibXklavier"
SRC_URI="mirror://sourceforge/gswitchit/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ~ppc64 sh sparc ~x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="||	(
				(
					||	( x11-misc/xkeyboard-config x11-misc/xkbdata )
					x11-apps/xkbcomp
					x11-libs/libX11
					x11-libs/libxkbfile
				)
				virtual/x11
			)
		dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-3.0-libxml.diff"
}


src_compile() {
	local xkbbase

	# see bug #113108
	if has_version x11-apps/xkbcomp; then
		xkbbase=/usr/share/X11/xkb
	else
		xkbbase=/usr/$(get_libdir)/X11/xkb
	fi

	econf --with-xkb-base=${xkbbase} --with-xkb-bin-base=/usr/bin \
		  $(use_enable doc doxygen) || die

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die

	insinto /usr/share/libxklavier
	use sparc && doins "${FILESDIR}/sun.xml"

	dodoc AUTHORS CREDITS ChangeLog NEWS README
}

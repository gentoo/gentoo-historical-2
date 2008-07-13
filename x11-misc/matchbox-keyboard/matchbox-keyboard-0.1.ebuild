# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/matchbox-keyboard/matchbox-keyboard-0.1.ebuild,v 1.5 2008/07/13 07:34:08 josejx Exp $

inherit versionator

DESCRIPTION="Matchbox-keyboard is an on screen 'virtual' or 'software' keyboard."
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~arm ~hppa ~ppc ~x86"
IUSE="debug cairo"

DEPEND="x11-libs/libfakekey
	cairo? ( x11-libs/cairo )
	!cairo? ( x11-libs/libXft )"

src_compile() {
	econf	$(use_enable debug) \
		$(use_enable cairo) \
		|| die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS Changelog INSTALL NEWS README
}

# Copyright 2006-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/matchbox-panel/matchbox-panel-0.9.3.ebuild,v 1.4 2007/09/26 04:01:17 jer Exp $

inherit eutils versionator

DESCRIPTION="The Matchbox Panel"
HOMEPAGE="http://projects.o-hand.com/matchbox/"
SRC_URI="http://projects.o-hand.com/matchbox/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~arm ~hppa ~x86"
IUSE="acpi debug dnotify lowres nls startup-notification"

DEPEND=">=x11-libs/libmatchbox-1.5
	startup-notification? ( x11-libs/startup-notification )
	nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}
	x11-wm/matchbox-common"

src_unpack () {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-gcc4-no-nested-functions.patch"
}

src_compile() {
	econf	$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable startup-notification) \
		$(use_enable dnotify) \
		$(use_enable acpi acpi-linux) \
		$(use_enable lowres small-icons) \
		|| die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR=${D} install || die "Installation failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}

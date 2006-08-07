# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/matchbox-applet-volume/matchbox-applet-volume-0.1.ebuild,v 1.2 2006/08/07 17:13:42 yvasilev Exp $

inherit versionator

MY_PN=${PN/matchbox/mb}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Matchbox panel tray app for controlling volume levels."
HOMEPAGE="http://projects.o-hand.com/matchbox/"
SRC_URI="http://projects.o-hand.com/matchbox/sources/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~arm"
IUSE=""

DEPEND=">=x11-libs/libmatchbox-1.5
	>=x11-libs/gtk+-2.0.3"

RDEPEND="${DEPEND}
	x11-wm/matchbox-panel"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR=${D} install || die "Installation failed"

	dodoc AUTHORS Changelog INSTALL NEWS README
}

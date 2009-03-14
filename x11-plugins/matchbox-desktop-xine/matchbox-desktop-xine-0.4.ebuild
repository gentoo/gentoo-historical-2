# Copyright 2006-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/matchbox-desktop-xine/matchbox-desktop-xine-0.4.ebuild,v 1.3 2009/03/14 03:51:47 solar Exp $

inherit versionator eutils

MY_PN=${PN/matchbox/mb}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A matchbox-desktop plugin that allows you to browse and play movies and music. Its in pretty early stages and should probably be considered alpha software"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=x11-libs/libmatchbox-1.1
	x11-wm/matchbox-desktop
	>=media-libs/xine-lib-1.0.0"

S="${WORKDIR}/${MY_P}"

src_compile () {
	econf $(use_enable debug) || die "Configuration failed"

	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS Changelog INSTALL NEWS README
}

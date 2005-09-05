# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-cleanice/gtk-engines-cleanice-0.8.5-r1.ebuild,v 1.3 2005/09/05 14:57:14 leonardop Exp $

MY_PN="gtk-cleanice-theme"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Cleanice theme engine for GTK+ 1"
HOMEPAGE="http://themes.freshmeat.net/"
SRC_PATH="${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz"
SRC_URI="mirror://debian/pool/main/${SRC_PATH}"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc x86"
LICENSE="GPL-2"
SLOT="1"
IUSE="static"

DEPEND="=x11-libs/gtk+-1.2*"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf="$(use_enable static)"

	econf $myconf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog README
}

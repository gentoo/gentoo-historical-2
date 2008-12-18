# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-candido/gtk-engines-candido-0.9.1.ebuild,v 1.3 2008/12/18 10:38:13 ssuominen Exp $

MY_P=candido-engine-${PV}

DESCRIPTION="Candido GTK+ Theme Engine"
HOMEPAGE="http://candido.berlios.de"
SRC_URI="mirror://berlios/candido/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf --disable-dependency-tracking --enable-animation
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog CREDITS NEWS README
}

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-lighthouseblue/gtk-engines-lighthouseblue-0.6.2-r1.ebuild,v 1.1.1.1 2005/11/30 09:51:38 chriswhite Exp $

MY_PN=lighthouseblue-gtk1
MY_P=${MY_PN}-${PV}
DESCRIPTION="LighthouseBlue GTK+ 1 theme engine"
HOMEPAGE="http://lighthouseblue.sourceforge.net/"
SRC_URI="mirror://sourceforge/lighthouseblue/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="1"

KEYWORDS="x86 ppc amd64"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*"

S=${WORKDIR}/${MY_PN}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS
}

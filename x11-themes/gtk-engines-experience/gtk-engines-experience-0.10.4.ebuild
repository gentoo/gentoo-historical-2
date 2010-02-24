# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-experience/gtk-engines-experience-0.10.4.ebuild,v 1.6 2010/02/24 14:48:47 ssuominen Exp $

MY_PN=experience
MY_P=${MY_PN}-${PV}

DESCRIPTION="GTK+ Experience Theme Engine"
HOMEPAGE="http://benjamin.sipsolutions.net/Projects/eXperience"
SRC_URI="http://benjamin.sipsolutions.net/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="amd64 ~ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

S=${WORKDIR}/${P/engines/engine}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-lirc/xmms-lirc-1.4.ebuild,v 1.8 2004/11/10 01:27:16 eradicator Exp $

IUSE=""

MY_P=${P/xmms-lirc/lirc-xmms-plugin}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="LIRC plugin for xmms to control xmms with your favorite remote control."
HOMEPAGE="http://www.lirc.org"
SRC_URI="mirror://sourceforge/lirc/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-sound/xmms
	app-misc/lirc"

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog lircrc NEWS README
}

pkg_postinst () {
	einfo
	einfo "You have to edit your .lircrc. You can find an example file at"
	einfo "/usr/share/doc/${PF}."
	einfo "And take a look at the README there."
	einfo
}

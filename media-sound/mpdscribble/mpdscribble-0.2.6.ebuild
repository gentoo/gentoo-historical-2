# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpdscribble/mpdscribble-0.2.6.ebuild,v 1.6 2005/12/09 22:31:47 chainsaw Exp $

DESCRIPTION="An MPD client that submits information to audioscrobbler."
HOMEPAGE="http://scribble.frob.nl/"
SRC_URI="http://warp.frob.nl/projects/scribble/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=">=net-libs/libsoup-2.2"

src_install() {
	make DESTDIR=${D} install || die

	exeinto /usr/share/mpdscribble
	doexe setup.sh

	doman mpdscribble.1
	newinitd ${FILESDIR}/mpdscribble.rc mpdscribble

	dodoc AUTHORS ChangeLog NEWS README TODO

	dodir /var/cache/mpdscribble
}

pkg_postinst() {
	einfo ""
	einfo "Please run:"
	einfo "  /usr/share/mpdscribble/setup.sh"
	einfo "in order to configure mpdscribble. If you do this as root, a"
	einfo "system-wide configuration will be created. Otherwise, a per-user"
	einfo "configuration file will be created."
	einfo ""
	einfo "To start mpdscribble:"
	einfo "  /etc/init.d/mpdscribble start"
	einfo ""
}

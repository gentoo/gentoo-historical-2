# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/audacious-docklet/audacious-docklet-0.1.1.ebuild,v 1.3 2006/02/25 23:18:58 halcy0n Exp $

DESCRIPTION="Audacious plugin that displays an icon in your systemtray"
SRC_URI="http://nedudu.hu/downloads/${P}.tar.bz2"
HOMEPAGE="http://nedudu.hu/?page_id=11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=media-sound/audacious-0.2"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )"

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README TODO
}

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/gtkpod/gtkpod-0.94.0.ebuild,v 1.4 2006/01/01 18:37:24 tester Exp $

DESCRIPTION="GUI for iPod using GTK2"
HOMEPAGE="http://gtkpod.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="aac"

DEPEND=">=x11-libs/gtk+-2.4.0
	>=media-libs/libid3tag-0.15
	>=gnome-base/libglade-2
	aac? ( || ( media-libs/libmp4v2
			<media-libs/faad2-2.0-r8
			<media-video/mpeg4ip-1.4.1 ) )"

src_unpack() {
	unpack ${A}

	# Disable aac forcefully if not enabled
	cd ${S}
	use aac || sed -i -e s/MP4FileInfo/MP4FileInfoDisabled/g configure
}

src_install() {
	einstall || die
	dodoc README ${DISTDIR}/Local_Playcounts.README
}

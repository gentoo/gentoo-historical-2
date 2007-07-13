# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k9copy/k9copy-1.1.0.ebuild,v 1.3 2007/07/13 05:40:32 mr_bones_ Exp $

inherit kde

MY_P="${P/_/-}"

DESCRIPTION="k9copy is a DVD backup utility which allow the copy of one or more titles from a DVD9 to a DVD5"
HOMEPAGE="http://k9copy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="media-video/dvdauthor
	media-libs/libdvdread
	media-libs/libdvdnav
	app-cdr/dvd+rw-tools
	>=media-video/vamps-0.98
	>=app-cdr/k3b-0.12.10
	dev-libs/dbus-qt3-old
	sys-apps/hal
	media-video/mplayer"
need-kde 3.3

S="${WORKDIR}/${MY_P}"

src_install() {
	kde_src_install

	dodoc README TODO ChangeLog NEWS

	dodir /usr/share/applications/kde
	mv "${D}/usr/share/applnk/Multimedia/k9copy.desktop" \
		"${D}/usr/share/applications/kde"

	# Add Categories to put k9copy in the right menu
	echo -e "\nCategories=Qt;KDE;Application;AudioVideo;" >> \
		"${D}/usr/share/applications/kde/k9copy.desktop"
}

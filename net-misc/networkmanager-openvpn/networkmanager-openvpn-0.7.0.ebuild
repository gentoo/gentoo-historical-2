# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager-openvpn/networkmanager-openvpn-0.7.0.ebuild,v 1.1 2008/12/04 23:38:27 scarabeus Exp $

inherit eutils

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}

DESCRIPTION="NetworkManager OpenVPN plugin."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI="mirror://gnome/sources/NetworkManager-openvpn/0.7/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~ppc ~x86"
IUSE="gnome"

RDEPEND="
	>=net-misc/networkmanager-0.7.0
	>=net-misc/openvpn-2.1_rc9
	gnome? (
		>=gnome-base/gconf-2.20
		>=gnome-base/gnome-keyring-2.20
		>=gnome-base/libglade-2
		>=gnome-base/libgnomeui-2.20
		>=x11-libs/gtk+-2.10
	)"

DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_compile() {
	ECONF="--disable-more-warnings \
		$(use_with gnome)"

	econf ${ECONF}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}

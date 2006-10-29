# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/docker/docker-1.5.ebuild,v 1.9 2006/10/29 21:30:49 omp Exp $

IUSE=""
DESCRIPTION="Openbox app which acts as a system tray for KDE and GNOME2"
SRC_URI="http://icculus.org/openbox/2/docker/${P}.tar.gz"
HOMEPAGE="http://icculus.org/openbox/2/docker/"

RDEPEND=">=dev-libs/glib-2.0.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc ~sparc x86"

src_install () {
	dobin docker || die "failed to install docker"
	dodoc COPYING README
}

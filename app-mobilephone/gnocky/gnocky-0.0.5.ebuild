# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/gnocky/gnocky-0.0.5.ebuild,v 1.1 2007/12/30 09:34:20 mrness Exp $

DESCRIPTION="GTK-2 version of gnokii"
HOMEPAGE="http://www.gnokii.org/"
SRC_URI="http://www.gnokii.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	gnome-base/libglade
	>=app-mobilephone/gnokii-0.6.22"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_install()
{
	einstall || die "make install failed"
}

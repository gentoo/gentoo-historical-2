# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxde-common/lxde-common-0.4.1.ebuild,v 1.1 2009/05/24 19:32:40 yngwin Exp $

EAPI="1"

DESCRIPTION="LXDE Session default configuration files and nuoveXT2 iconset"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}

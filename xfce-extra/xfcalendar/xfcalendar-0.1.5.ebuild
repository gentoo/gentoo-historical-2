# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfcalendar/xfcalendar-0.1.5.ebuild,v 1.4 2004/03/03 01:18:24 gustavoz Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Xfce4 panel calendar plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce-4.0.3/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ia64 x86 ~ppc ~alpha sparc ~amd64 ~hppa"

DEPEND=">=x11-libs/gtk+-2.0.6
	dev-util/pkgconfig
	dev-libs/libxml2
	>=xfce-base/xfce4-base-4.0.3
	>=xfce-base/libxfce4util-4.0.3
	>=xfce-base/libxfcegui4-4.0.3
	>=xfce-base/libxfce4mcs-4.0.3
	>=xfce-base/xfce-mcs-manager-4.0.3"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL COPYING README ChangeLog
}

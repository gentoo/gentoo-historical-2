# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/libtomoe-gtk/libtomoe-gtk-0.4.0.ebuild,v 1.1 2006/12/02 08:26:20 matsuu Exp $

DESCRIPTION="Tomoe GTK+ interface widget library"
HOMEPAGE="http://tomoe.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoe/22894/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-i18n/tomoe-0.4.0
	>=x11-libs/gtk+-2.4.0"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README
}

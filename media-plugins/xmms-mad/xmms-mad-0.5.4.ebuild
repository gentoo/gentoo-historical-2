# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-mad/xmms-mad-0.5.4.ebuild,v 1.3 2004/01/21 09:27:27 raker Exp $

DESCRIPTION="A XMMS plugin for MAD"
HOMEPAGE="http://xmms-mad.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmms-mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND="media-sound/xmms
	>=media-sound/mad-0.14.2b-r2
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die "Make failed"
	dodoc AUTHORS COPYING ChangeLog NEWS README
}

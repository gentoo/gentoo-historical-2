# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-sid/xmms-sid-0.8.0_beta10.ebuild,v 1.3 2004/06/24 23:45:37 agriffis Exp $

MY_PV=${PV/_beta/beta}
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="C64 SID plugin for XMMS"
HOMEPAGE="http://www.tnsp.org/xmms-sid.php"
SRC_URI="http://tnsp.org/xs-files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~alpha ~hppa ~ppc"

IUSE=""

DEPEND="media-sound/xmms
	=media-libs/libsidplay-1.36*"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS COPYING ChangeLog INSTALL README* NEWS TODO
}

# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/efxmms/efxmms-0.0.3.ebuild,v 1.1 2002/10/29 13:29:23 seemant Exp $

MY_P=${PN/efx/EFX}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Provides the possibility to send the audio through a queue of multiple effect plugins instead of one effect that XMMS originally handles"
SRC_URI="mirror://sourceforge/efxmms/${MY_P}.tar.bz2"
HOMEPAGE="http://sourceforge.net/projects/efxmms"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="media-sound/xmms"


src_install() {

	einstall \
		libdir=${D}/usr/lib/xmms/Effect || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README  README.EFX TODO
}

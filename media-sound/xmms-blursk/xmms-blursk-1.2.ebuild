# Copyright 1999-20022 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmms-blursk/xmms-blursk-1.2.ebuild,v 1.2 2002/07/22 00:48:13 seemant Exp $


MY_P="Blursk-${PV}"
S=${WORKDIR}/${MY_P}
SRC_URI="http://www.cs.pdx.edu/~kirkenda/blursk/${MY_P}.tar.gz"
HOMEPAGE="http://www.cs.pdx.edu/~kirkenda/blursk/"
DESCRIPTION="Yet another psychedelic visualization plug-in for XMMS"

DEPEND="=x11-libs/gtk+-1.2*
	>=media-sound/xmms-1.2.6-r5"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"


src_install () {

	make DESTDIR=${D} install || die "install failed"

	dodoc AUTHORS COPYING ChangeLog INSTALL README NEWS

}

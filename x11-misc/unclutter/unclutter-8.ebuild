# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/unclutter/unclutter-8.ebuild,v 1.9 2004/06/24 22:34:59 agriffis Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Hides mouse pointer while not in use."
HOMEPAGE="http://www.ibiblio.org/pub/X11/contrib/utilities/unclutter-8.README"
SRC_URI="ftp://ftp.x.org/contrib/utilities/${P}.tar.Z"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="x86 ~ppc ~sparc alpha ~mips hppa"
IUSE=""

DEPEND="virtual/x11"


src_compile() {
	xmkmf -a || die "Couldn't run xmkmf"
	make || die
}

src_install () {
	make DESTDIR=${D} install || die

	newman unclutter.man unclutter.1x

	dodoc README
}

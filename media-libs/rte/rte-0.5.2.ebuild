# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/rte/rte-0.5.2.ebuild,v 1.1 2004/08/28 11:57:46 mholzer Exp $

inherit eutils

IUSE="esd alsa divx4linux"

DESCRIPTION="Real Time Encoder"
SRC_URI="mirror://sourceforge/zapping/${P}.tar.bz2"
HOMEPAGE="http://zapping.sourceforge.net/"

DEPEND="esd? ( media-sound/esound )
	alsa? ( media-libs/alsa-lib )
	divx4linux? ( ~media-libs/divx4linux-20020418 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 -sparc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/config.patch
}

src_compile() {
	econf `use_with divx4linux` || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	einstall || die "einstall failed"
	dodoc AUTHORS COPYING ChangeLog NEWS README
}

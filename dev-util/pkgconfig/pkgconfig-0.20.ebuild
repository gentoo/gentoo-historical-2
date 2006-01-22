# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pkgconfig/pkgconfig-0.20.ebuild,v 1.4 2006/01/22 13:41:23 dertobi123 Exp $

inherit flag-o-matic

MY_P="pkg-config"-${PV}
DESCRIPTION="Package config system that manages compile/link flags"
HOMEPAGE="http://pkgconfig.freedesktop.org/wiki/"

SRC_URI="http://pkgconfig.freedesktop.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="hardened"

DEPEND=""

S=${WORKDIR}/${MY_P}


src_unpack() {
	unpack "${A}"

	use ppc64 && use hardened && replace-flags -O[2-3] -O1
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog NEWS README
}

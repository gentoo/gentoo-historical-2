# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/debootstrap/debootstrap-0.2.31.ebuild,v 1.3 2004/06/25 02:27:41 agriffis Exp $

DESCRIPTION="Debian bootstrap scripts"
HOMEPAGE="http://packages.qa.debian.org/d/debootstrap.html"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~amd64"
SRC_URI="mirror://debian/pool/main/d/debootstrap/debootstrap_${PV}.tar.gz
	mirror://gentoo/devices.tar.gz"
DEPEND="sys-devel/binutils
	net-misc/wget
	app-arch/dpkg"
IUSE=""

src_unpack() {
	unpack debootstrap_$PV.tar.gz
	cp ${DISTDIR}/devices.tar.gz ${S}
}

src_compile() {
	sed -i -e "s/chown/#chown/" Makefile
	make pkgdetails debootstrap-arch
}

src_install() {
	make DESTDIR=${D} install
}

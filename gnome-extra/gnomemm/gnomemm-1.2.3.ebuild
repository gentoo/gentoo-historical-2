# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnomemm/gnomemm-1.2.3.ebuild,v 1.6 2002/12/09 04:22:40 manson Exp $

inherit gcc

S=${WORKDIR}/${P}
DESCRIPTION="C++ binding for the GNOME libraries"
SRC_URI="mirror://sourceforge/gtkmm/${P}.tar.gz"
HOMEPAGE="http://gtkmm.sourceforge.net/"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 sparc "

RDEPEND="=x11-libs/gtkmm-1.2*
		 >=gnome-base/ORBit-0.5.11
		 =sys-libs/db-1*"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}

	if [ "$(gcc-major-version)" == 2 ]
	then
		cd ${S}/src
		patch < ${FILESDIR}/${P}-gentoo.patch
	fi
}

src_compile() {
	
	./configure --host=${CHOST} \
		--prefix=/usr || die

	emake || die
}

src_install() {

	make DESTDIR=${D} \
		install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README* TODO
}

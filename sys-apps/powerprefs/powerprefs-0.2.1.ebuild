# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/powerprefs/powerprefs-0.2.1.ebuild,v 1.2 2002/06/21 20:43:27 gerk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="powerprefs is a PPC-only program to interface with special Powerbook/iBook keys in Linux"
SRC_URI="http://www.cymes.de/members/joker/projects/pbbuttons/tar/${P}.tar.gz"
HOMEPAGE="http://www.cymes.de/members/joker/projects/pbbuttons/pbbuttons.html"
SLOT="0"
LICENSE=GPL
DEPEND="x11-libs/gtk+"
RDEPEND="sys-apps/pbbuttonsd"

src_compile() {

        if [ ${ARCH} = "x86" ] ; then
                einfo "PPC Only build, sorry"
                exit 1
        fi

	./configure --prefix=/usr || die "sorry, ppc-only package"
	make || die "sorry, powerprefs compile failed"
}

src_install() {

	make \
		prefix=${D}/usr \
		mandir={D}/usr/share/man \
		infodir={D}/usr/share/info \
		install || die "sorry, failed to install powerprefs"

	dodoc README COPYING

}

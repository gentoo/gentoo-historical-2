# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnobog/gnobog-0.4.3.ebuild,v 1.1 2002/05/28 18:32:53 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Gnome Bookmarks Organizer"
SRC_URI="http://freesoftware.fsf.org/download/${PN}/${P}.tar.gz"
HOMEPAGE="http://gnobog.sourceforge.net"

DEPEND=">=gnome-base/libglade-0.17-r5"
RDEPEND="$DEPEND"
LICENSE="GPL-2"
SLOT="0"
src_compile() {
    ./configure \
		--host=${CHOST}	\
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--datadir=/usr/share \
		--includedir=/usr/include/libglade-1.0 || die "configure failed"

    emake || die "Compile failed"
}

src_install () {

    make \
		prefix=${D}/usr \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		datadir=${D}/usr/share \
		install || die "install failed"

    dodoc ChangeLog README
}


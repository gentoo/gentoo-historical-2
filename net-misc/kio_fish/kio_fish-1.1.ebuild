# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Maintainer Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/kio_fish/kio_fish-1.1.ebuild,v 1.3 2002/04/13 16:43:43 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

S=${WORKDIR}/${P}
need-kde 3
newdepend ">=net-misc/openssh-3.1_p1"
DESCRIPTION="a kioslave for KDE 3 that lets you view and manipulate 
your remote files using SSH"
SRC_URI="http://ich.bin.kein.hoschi.de/fish/${P}.tar.gz"
HOMEPAGE="http://ich.bin.kein.hoschi.de/fish/"

src_install() {

	mkdir -p ${D}/usr/kde/3/share/services
	make DESTDIR=${D} install || die
	

}

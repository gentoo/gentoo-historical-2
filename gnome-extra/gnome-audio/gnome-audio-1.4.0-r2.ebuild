# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-audio/gnome-audio-1.4.0-r2.ebuild,v 1.4 2002/12/09 04:22:39 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="gnome-audio"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc "

DEPEND=""
RDEPEND=""
src_install() {
	make prefix=${D}/usr 						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die
	dodoc README
}

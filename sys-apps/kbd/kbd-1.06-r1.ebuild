# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License
# /space/gentoo/cvsroot/gentoo-x86/sys-apps/mosix-user/mosix-user-1.5.2.ebuild,v 1.4 2001/11/25 02:40:12 drobbins Exp

S=${WORKDIR}/${P}
DESCRIPTION="Keyboard and console utilities"
SRC_URI="ftp://ftp.win.tue.nl/pub/home/aeb/linux-local/utils/kbd/${P}.tar.gz"
HOMEPAGE=""
DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"
PROVIDE="sys-apps/console-tools"

src_compile() {
	local myopts

	if [ -z "`use nls`" ] 
	then
		myopts="--disable-nls"
	else
		myopts="--enable-nls"
	fi

	./configure --mandir=/usr/share/man \
		--datadir=/usr/share \
		${myopts} || die
	make || die
}

src_install() {
	make  \
		DESTDIR=${D}	\
		DATADIR=${D}/usr/share	\
		MANDIR=${D}/usr/share/man	\
		install || die
}

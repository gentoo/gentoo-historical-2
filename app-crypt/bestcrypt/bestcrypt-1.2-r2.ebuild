# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-1.2-r2.ebuild,v 1.3 2002/12/24 16:35:58 lostlogic Exp $

MY_PN="bcrypt"
MY_PV="`echo ${PVR}|sed -e s:-r:-:`"
KEYWORDS="~x86"
SRC_URI="http://www.jetico.com/linux/BestCrypt-${MY_PV}.tar.gz"
HOMEPAGE="http://www.jetico.com"
DESCRIPTION="Transparent filesystem encryption.  This is a Commercially Licensed Package, please read the license and ChangeLog for more information."
S=${WORKDIR}/${MY_PN}	
LICENSE="bestcrypt"
SLOT="0"
DEPEND="virtual/linux-sources"

src_unpack() {
	unpack ${A}
	for file in `find . -type f -iname Makefile*`;do
		mv ${file} ${file}.orig
		sed -e "s:-O[0-9]:${CFLAGS}:"	\
		    -e 's%KVER =.*%KVER = $(shell readlink /usr/src/linux|sed -e "s:linux-\\([0-9]\\+\.[0-9]\\+\\)\..*:\\1:")%' \
		    -e "s%uname -r%readlink /usr/src/linux|sed -e 's:linux-::'%" \
			${file}.orig > ${file}

	done
}

src_compile() {
	MAKEOPTS="-j1" emake
}

src_install() {
	exeinto /etc/rc.d/init.d
	doexe ${FILESDIR}/bcrypt
	dodir	/usr/bin		\
		/etc/init.d		\
		/etc/rc.d/rc0.d		\
		/etc/rc.d/rc1.d		\
		/etc/rc.d/rc2.d		\
		/etc/rc.d/rc3.d		\
		/etc/rc.d/rc4.d		\
		/etc/rc.d/rc5.d		\
		/etc/rc.d/rc6.d		\
		/etc/rc0.d		\
		/etc/rc1.d		\
		/etc/rc2.d		\
		/etc/rc3.d		\
		/etc/rc4.d		\
		/etc/rc5.d		\
		/etc/rc6.d		\
		/usr/share/man/man8	\
		/lib/modules/${KV}/kernel/drivers/block/
	einstall MAN_PATH="/usr/share/man" \
		 root="${D}" \
		 MOD_PATH=/lib/modules/${KV}/kernel/drivers/block
	exeinto /etc/init.d
	doexe ${FILESDIR}/bcrypt
	rm -rf ${D}/etc/rc*.d
	dodoc README LICENSE
}

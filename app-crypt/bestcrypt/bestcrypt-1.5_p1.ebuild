# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-1.5_p1.ebuild,v 1.4 2004/06/24 21:30:10 agriffis Exp $

inherit flag-o-matic

MY_PN="bcrypt"
DESCRIPTION="commercially licensed transparent filesystem encryption"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="http://www.jetico.com/linux/BestCrypt-${PV/_p/-}.tar.gz"

LICENSE="bestcrypt"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND="virtual/linux-sources"

S=${WORKDIR}/bcrypt

pkg_setup() {
	if [ -e /usr/src/linux/include/linux/modsetver.h ] &&
	   [ ! -e /usr/src/linux/include/linux/modversions.h ]; then
		einfo "Setting modsetver->modversions symlink"
		ln -s /usr/src/linux/include/linux/modsetver.h \
		      /usr/src/linux/include/linux/modversions.h
	fi
}

src_unpack() {
	filter-flags -fforce-addr
	unpack ${A}
	for file in `find . -type f -iname Makefile*`;do
		sed -i -e "s:-O[0-9]:${CFLAGS}:"	\
		    -e 's%KVER =.*%KVER = $(shell readlink /usr/src/linux|sed -e "s:linux-\\([0-9]\\+\\.[0-9]\\+\\)\\..*:\\1:")%' \
		    -e "s%uname -r%readlink /usr/src/linux|sed -e 's:linux-::'%" \
			 ${file}

	done
}

src_compile() {
	emake -j1 || die
}

src_install() {
	exeinto /etc/rc.d/init.d
	doexe ${FILESDIR}/bcrypt
	dodir \
		/usr/bin \
		/etc/init.d \
		/etc/rc.d/rc{0,1,2,3,4,5,6}.d \
		/etc/rc{0,1,2,3,4,5,6}.d \
		/usr/share/man/man8 \
		/lib/modules/${KV}/kernel/drivers/block
	einstall MAN_PATH="/usr/share/man" \
		 root="${D}" \
		 MOD_PATH=/lib/modules/${KV}/kernel/drivers/block
	exeinto /etc/init.d
	newexe ${FILESDIR}/bcrypt2 bcrypt
	rm -rf ${D}/etc/rc*.d
	dodoc README LICENSE
}

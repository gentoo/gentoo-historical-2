# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-1.5_p2.ebuild,v 1.3 2004/06/24 21:30:10 agriffis Exp $

inherit flag-o-matic eutils check-kernel

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
	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${P}-makefile_fix.patch

	get_KV_info
	if [ "${KV_major}" == "2" -a "${KV_minor}" == "6" -a "${KV_micro}" -ge "4" ]; then
		epatch ${FILESDIR}/${P}-bdev_file_fix.patch
	fi
}

src_compile() {
	filter-flags -fforce-addr

	emake -j1 EXTRA_CFLAGS="${CFLAGS}" EXTRA_CXXFLAGS="${CXXFLAGS}" || die
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

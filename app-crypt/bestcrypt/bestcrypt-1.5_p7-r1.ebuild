# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bestcrypt/bestcrypt-1.5_p7-r1.ebuild,v 1.4 2005/01/03 04:33:12 dragonheart Exp $

inherit flag-o-matic eutils check-kernel

MY_PN="bcrypt"
DESCRIPTION="commercially licensed transparent filesystem encryption"
HOMEPAGE="http://www.jetico.com/"
SRC_URI="mirror://gentoo/BestCrypt-${PV/_p/-}.tar.gz http://www.carceri.dk/files/bcrypt-rc6-serpent.diff.gz"

LICENSE="bestcrypt"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

DEPEND="virtual/linux-sources"

S=${WORKDIR}/bcrypt

src_unpack() {
	unpack BestCrypt-${PV/_p/-}.tar.gz
	cd ${S}

	epatch ${DISTDIR}/bcrypt-rc6-serpent.diff.gz
	epatch ${FILESDIR}/${P}-makefile_fix.patch
}

src_compile() {
	filter-flags -fforce-addr

	emake -j1 EXTRA_CFLAGS="${CFLAGS}" EXTRA_CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
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
	newexe ${FILESDIR}/bcrypt3 bcrypt
	rm -rf ${D}/etc/rc*.d
	dodoc README LICENSE

	einfo "If you are using the serpent or rc6 encryption modules and have any problems,"
	einfo "please submit bugs to http://bugs.gentoo.org because these modules are not part"
	einfo "of the standard distribution of BestCrypt for Linux released by Jetico."
	einfo "For more information on these additional modules:"
	einfo "visit http://www.carceri.dk/index.php?redirect=other_bestcrypt"
}

pkg_postinst() {
	ebegin "Updating modules"
	update-modules > /dev/null 2>&1
	eend $?
}

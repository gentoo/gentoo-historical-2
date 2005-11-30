# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_throttle/mod_throttle-3.1.2-r1.ebuild,v 1.1 2002/05/04 23:23:02 woodchip Exp $

DESCRIPTION="Bandwidth and request throttling for Apache"
HOMEPAGE="http://www.snert.com/Software/mod_throttle/"

MY_V="`echo ${PV} | sed -e 's:\.::g'`"
S=${WORKDIR}/${P}
SRC_URI="http://www.snert.com/Software/${PN}/${PN}${MY_V}.tgz"

DEPEND="virtual/glibc >=net-www/apache-1.3.24"
LICENSE="as-is"
SLOT="0"

src_compile() {
	make || die "compile problem"
}

src_install() {
	exeinto /usr/lib/apache-extramodules
	doexe mod_throttle.so

	dodoc CHANGES.txt LICENSE.txt
	dohtml index.shtml

	insinto /etc/apache/conf/addon-modules
	doins ${FILESDIR}/mod_throttle.conf
}

pkg_postinst() {
	einfo
	einfo "Execute \"ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config\""
	einfo "to have your apache.conf auto-updated for use with this module."
	einfo "You should then edit your /etc/conf.d/apache file to suit."
	einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/mod_throttle.so mod_throttle.c throttle_module \
		define=THROTTLE addconf=conf/addon-modules/mod_throttle.conf
	:;
}

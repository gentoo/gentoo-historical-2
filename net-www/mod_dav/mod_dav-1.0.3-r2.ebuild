# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_dav/mod_dav-1.0.3-r2.ebuild,v 1.4 2004/09/15 00:23:17 pvdabeel Exp $

inherit eutils

MY_V=${PV}-1.3.6

DESCRIPTION="Apache module for Distributed Authoring and Versioning"
HOMEPAGE="http://www.webdav.org/mod_dav/"
KEYWORDS="~x86 sparc ppc ~amd64"

S=${WORKDIR}/${PN}-${MY_V}
SRC_URI="http://www.webdav.org/mod_dav/${PN}-${MY_V}.tar.gz"

DEPEND="virtual/libc =net-www/apache-1*"
LICENSE="as-is"
SLOT="0"
IUSE=""

src_unpack() {
	unpack ${A} ; cd ${S}
	patch -p1 < ${FILESDIR}/${PN}-shared-expat.patch || die
	epatch ${FILESDIR}/mod_dav_fs_lock.patch
	autoconf || die
}

src_compile() {
	./configure --host=${CHOST} || die
	emake || die "compile problem"
}

src_install() {
	exeinto /usr/lib/apache-extramodules
	doexe libdav.so

	dodoc README CHANGES INSTALL
	dohtml LICENSE.html

	insinto /etc/apache/conf/addon-modules
	doins ${FILESDIR}/mod_dav.conf
}

pkg_postinst() {
	# empty lock dir..
	install -m0750 -o apache -g apache -d ${ROOT}/var/lock/mod_dav

	einfo
	einfo "Execute \"ebuild /var/db/pkg/net-www/${PF}/${PF}.ebuild config\""
	einfo "to have your apache.conf auto-updated for use with this module."
	einfo "You should then edit your /etc/conf.d/apache file to suit."
	einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/libdav.so mod_dav.c dav_module \
		define=DAV addconf=conf/addon-modules/mod_dav.conf
	:;
}

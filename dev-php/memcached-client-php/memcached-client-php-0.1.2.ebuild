# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/memcached-client-php/memcached-client-php-0.1.2.ebuild,v 1.9 2005/04/01 04:47:44 agriffis Exp $

DESCRIPTION="Alternative high-speed PHP classes for interaction with MemCached"
HOMEPAGE="http://phpca.cytherianage.net/memcached"
SRC_URI="${HOMEPAGE}/dist/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc ia64 ~sparc ~amd64"
IUSE=""
DEPEND=""

src_install() {
	insinto /usr/lib/php/memcached/
	doins memcached-client.php
	dodoc README LICENSE ChangeLog
	dodir /usr/share/doc/${PF}
	cp -ra doc ${D}/usr/share/doc/${PF}/html
	prepalldocs
}

pkg_postinst() {
	einfo "This package does NOT depend on net-www/memcached as it is capable of operation as a remote client"
}

# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mod_auth_pgsql/mod_auth_pgsql-0.9.12.ebuild,v 1.12 2005/06/06 18:58:14 nakano Exp $

DESCRIPTION="This module allows user authentication (and can log authentication requests) against information stored in a PostgreSQL database."
SRC_URI="http://www.giuseppetanzilli.it/mod_auth_pgsql/dist/${P}.tar.gz"
HOMEPAGE="http://www.giuseppetanzilli.it/mod_auth_pgsql/"
KEYWORDS="x86 ~amd64"
LICENSE="freedist"
SLOT="0"
DEPEND=">=net-www/apache-1.3.27
	dev-db/postgresql"
IUSE=""

src_compile() {
	econf --with-apxs=/usr/sbin/apxs --with-pgsql-lib=/usr/lib/postgresql \
	--with-pgsql-include=/usr/include/postgresql || die "econf failed"
	/usr/sbin/apxs -I/usr/include/postgresql \
		-L/usr/lib/postgresql -lpq \
		-o mod_auth_pgsql.so -c mod_auth_pgsql.c auth_pgsql_shared_stub.c || die
}

src_install() {
	insinto /usr/lib/apache-extramodules
	doins mod_auth_pgsql.so
}

pkg_postinst() {
	einfo
	einfo "To have Apache run auth_pgsql programs, please do the following:"
		einfo "1. Execute the command:"
		einfo " \"ebuild /var/db/pkg/net-www/${PF}/${PF}.ebuild config\""
		einfo "2. Edit /etc/conf.d/apache and add \"-D AUTH_PGSQL\""
		einfo
}

pkg_config() {
	${ROOT}/usr/sbin/apacheaddmod \
		${ROOT}/etc/apache/conf/apache.conf \
		extramodules/mod_auth_pgsql.so mod_auth_pgsql.c auth_pgsql_module \
		before=perl define=AUTH_PGSQL
	:;
}


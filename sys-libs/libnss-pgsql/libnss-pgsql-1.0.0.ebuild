# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libnss-pgsql/libnss-pgsql-1.0.0.ebuild,v 1.1 2005/01/12 10:26:13 nakano Exp $

inherit eutils

DESCRIPTION="Name Service Switch module for use with PostgreSQL"
HOMEPAGE="http://sourceforge.net/projects/sysauth-pgsql"
SRC_URI="mirror://sourceforge/sysauth-pgsql/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/libc
	>=dev-db/postgresql-7.4-r1"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/postgres-and-glibc.patch
}

src_compile() {
	econf --libdir=/lib || die "econf failure"
	emake || die "emake failure"
}

src_install() {
	make DESTDIR=${D} install || die "make install failure"
	dodoc AUTHORS ChangeLog INSTALL NEWS README
	insinto etc		&& doins conf/nss-pgsql.conf
	docinto conf	&& dodoc conf/{dbschema.sql,nsswitch.conf}
	docinto doc		&& dodoc doc/{nss-pgsql.{ps,sgml,txt}}
}

pkg_postinst() {
	einfo "Now create the required SQL tables in a database, eg.:"
	einfo "  $ zcat /usr/share/doc/${P}/conf/dbschema.sql.gz | psql dbtest"
	einfo "Then edit the config file to match your need:"
	einfo "  /etc/nss-pgsql.conf"
	einfo "Now edit /etc/nsswitch.conf to use the NSS service 'pgsql', an"
	einfo "example is available here:"
	einfo " /usr/share/doc/${P}/conf/nsswitch.conf.gz"
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgpool/pgpool-3.0.1.ebuild,v 1.4 2010/06/17 18:17:19 patrick Exp $

DESCRIPTION="Connection pool server for PostgreSQL"
HOMEPAGE="http://pgpool.projects.postgresql.org/"
SRC_URI="http://pgfoundry.org/frs/download.php/733/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-db/postgresql-base"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "/^logdir/s:/tmp:/var/run:g" pgpool.conf.sample || die
}

src_compile() {
	econf --with-pgsql=/usr/include/postgresql || die
	emake || die
}

src_install () {
	einstall || die
	mv ${D}/etc/pgpool.conf.sample ${D}/etc/pgpool.conf
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README* TODO
	newinitd ${FILESDIR}/${PN}.init ${PN}
}

# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgpool/pgpool-2.0.3.ebuild,v 1.1 2004/07/16 17:37:44 matsuu Exp $

DESCRIPTION="Connection pool server for PostgreSQL"
SRC_URI="ftp://ftp.sra.co.jp/pub/cmd/postgres/pgpool/${P}.tar.gz"
HOMEPAGE="http://www2b.biglobe.ne.jp/~caco/pgpool/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""

DEPEND="dev-db/postgresql"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:/tmp:/var/run:g" pgpool.conf.sample || die
}

src_compile() {
	econf --with-pgsql=/usr/include/postgresql || die
	emake || die
}

src_install () {
	einstall || die
	mv ${D}/etc/pgpool.conf.sample ${D}/etc/pgpool.conf
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README* TODO
	exeinto /etc/init.d
	newexe ${FILESDIR}/${PN}.init ${PN}
}

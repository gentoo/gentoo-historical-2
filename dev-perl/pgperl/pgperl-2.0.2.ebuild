# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/pgperl/pgperl-2.0.2.ebuild,v 1.4 2004/06/25 00:55:19 agriffis Exp $

inherit perl-module

CATEGORY="dev-perl"
DESCRIPTION="native Perl interface to PostgreSQL"
SRC_URI="ftp://gborg.postgresql.org/pub/pgperl/stable/${P}.tar.gz"
HOMEPAGE="http://gborg.postgresql.org/project/pgperl/projdisplay.php"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=">=dev-db/postgresql-7.3.2"

S=${WORKDIR}/Pg-${PV}
src_compile() {
	export POSTGRES_HOME=/var/lib/postgresql
	perl-module_src_compile
}


# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc2-postgresql/jdbc2-postgresql-7.2.ebuild,v 1.6 2004/06/24 22:32:13 agriffis Exp $

inherit java-pkg

At="pg72jdbc2.jar"
S=${WORKDIR}
DESCRIPTION="JDBC Driver for PostgreSQL"
SRC_URI="http://jdbc.postgresql.org/download/${At}"
HOMEPAGE="http://jdbc.postgresql.org/"
KEYWORDS="x86 ppc sparc"
LICENSE="POSTGRESQL"
SLOT="4"
DEPEND=""
RDEPEND=">=virtual/jdk-1.2"

src_compile() {
	einfo "This is a binary-only ebuild (for now)."
}

src_install() {
	java-pkg_dojar ${DISTDIR}/${At}
}

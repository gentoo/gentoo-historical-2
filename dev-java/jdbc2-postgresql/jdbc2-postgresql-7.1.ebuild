# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc2-postgresql/jdbc2-postgresql-7.1.ebuild,v 1.9 2005/03/13 19:29:47 corsair Exp $

inherit java-pkg

At="jdbc7.1-1.2.jar"
S=${WORKDIR}
DESCRIPTION="JDBC Driver for PostgreSQL"
SRC_URI="http://jdbc.postgresql.org/download/${At}"
HOMEPAGE="http://jdbc.postgresql.org/"
KEYWORDS="x86 ppc sparc ~amd64"
IUSE=""
LICENSE="POSTGRESQL"
SLOT="3"
DEPEND=""
RDEPEND=">=virtual/jdk-1.2"

src_compile() {
	einfo "This is a binary-only ebuild (for now)."
}

src_install() {
	java-pkg_dojar ${DISTDIR}/${At}
}

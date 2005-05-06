# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/hk_classes/hk_classes-0.7.2.ebuild,v 1.3 2005/05/06 09:47:02 swegener Exp $

inherit eutils

P_DOCS="hk_docs-0.7"

MY_P=${P/_alpha/-test}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GUI-independent C++ libraries for database applications, including API documentation and tutorials."
HOMEPAGE="http://hk-classes.sourceforge.net/"
SRC_URI="mirror://sourceforge/hk-classes/${MY_P}.tar.bz2
		 mirror://sourceforge/knoda/knodapython.tar.bz2
		 mirror://sourceforge/knoda/${P_DOCS}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="mysql postgres sqlite odbc doc"

# At least one of the following is required
DEPEND="mysql? ( >=dev-db/mysql-3.23.54a )
	postgres? ( >=dev-db/postgresql-7.3 )
	sqlite? ( >=dev-db/sqlite-2 )
	odbc? ( >=dev-db/unixODBC-2.0.6 )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-amd64.patch
}

src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	use doc && dohtml -r ${WORKDIR}/${P_DOCS}/*
	use doc && dohtml -r ${WORKDIR}/knodapythondoc
	make DESTDIR=${D} install || die
}

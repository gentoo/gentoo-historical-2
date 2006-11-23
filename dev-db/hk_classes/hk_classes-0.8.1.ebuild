# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/hk_classes/hk_classes-0.8.1.ebuild,v 1.4 2006/11/23 19:55:29 vivo Exp $

inherit eutils python

RESTRICT="nostrip"

P_DOCS="hk_classes-htmldocumentation-0.8"

MY_P=${P/_alpha/-test}a
S=${WORKDIR}/${MY_P}

DESCRIPTION="GUI-independent C++ libraries for database applications, including API documentation and tutorials."
HOMEPAGE="http://hk-classes.sourceforge.net/"
SRC_URI="mirror://sourceforge/hk-classes/${MY_P}.tar.bz2
	mirror://sourceforge/hk-classes/xbsql-hk_classes-0.13.tar.gz
	doc? ( mirror://sourceforge/knoda/${P_DOCS}.tar.bz2 )"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc firebird mysql odbc postgres"

RDEPEND="firebird? ( dev-db/firebird )
	mysql? ( virtual/mysql )
	postgres? ( >=dev-db/postgresql-7.3 )
	odbc? ( >=dev-db/unixODBC-2.0.6 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	python_version
	export LIBPYTHON="-lpython${PYVER} -lz"

	myconf="--with-pythondir=/usr/$(get_libdir)/python${PYVER}/\
		`use_with mysql`\
		`use_with firebird`\
		`use_with odbc`\
		`use_with postgres`"

	econf ${myconf} || die "econf failed"
	emake || die "make failes"
}

src_install() {
	use doc && dohtml -r ${WORKDIR}/${MY_P}/documentation/api
	use doc && dohtml -r ${WORKDIR}/hk_classestutorial
	use doc && dohtml -r ${WORKDIR}/hk_kdeclssestutorial
	use doc && dohtml -r ${WORKDIR}/knodascriptingtutorial
	use doc && dohtml -r ${WORKDIR}/knodatutorial
	use doc && dohtml -r ${WORKDIR}/pythonreference

	make DESTDIR=${D} install || die "make install failed"
}

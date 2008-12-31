# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/gigabase/gigabase-3.67.ebuild,v 1.3 2008/12/31 17:45:32 armin76 Exp $

inherit eutils multilib

DESCRIPTION="OO-DBMS with interfaces for C/C++/Java/PHP/Perl"
HOMEPAGE="http://www.garret.ru/~knizhnik/gigabase.html"
SRC_URI="mirror://sourceforge/gigabase/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 s390 x86"
IUSE="doc"
DEPEND=""

S=${WORKDIR}/gigabase

src_compile() {
	mf="${S}/Makefile"

	econf || die "econf failed"

	sed -r -i -e 's/subsql([^\.]|$)/subsql-gdb\1/' ${mf}

	emake || die "compilation failed"
}

src_install() {
	einstall || die "make install failed"

	dodoc CHANGES
	use doc && dohtml GigaBASE.htm
	use doc && dohtml -r docs/html/*
}

pkg_postinst() {
	elog "The subsql binary has been renamed to subsql-gdb,"
	elog "to avoid a name clash with the FastDB version of subsql"
	echo
	ewarn "Content of indices created by old (<=3.42) version of GigaBASE with"
	ewarn "USE_LOCALE_SETTINGS enabled and using non-standard locale will be"
	ewarn "different with format used by version 3.43 and higher. So you will"
	ewarn "have to recreate indices in this case."
}

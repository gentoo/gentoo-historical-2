# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlite/sqlite-3.3.12.ebuild,v 1.4 2007/03/10 18:18:52 chtekk Exp $

inherit eutils alternatives libtool

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

DESCRIPTION="SQLite: an SQL Database Engine in a C Library."
HOMEPAGE="http://www.sqlite.org/"
SRC_URI="http://www.sqlite.org/${P}.tar.gz"
LICENSE="as-is"
SLOT="3"
IUSE="debug doc nothreadsafe tcl"

DEPEND="doc? ( dev-lang/tcl )
		tcl? ( dev-lang/tcl )"

RDEPEND="tcl? ( dev-lang/tcl )"

SOURCE="/usr/bin/lemon"
ALTERNATIVES="${SOURCE}-3 ${SOURCE}-0"

src_unpack() {
	# test
	if has test ${FEATURES} ; then
		if ! has userpriv ${FEATURES} ; then
			ewarn "The userpriv feature must be enabled to run tests."
			eerror "Testsuite will not be run."
		fi
		if ! use tcl ; then
			eerror "The tcl USE flag must be enabled to run tests."
			ewarn "Please note that turning on tcl installs runtime"
			ewarn "support too."
			eerror "Testsuite will not be run."
		fi
	fi

	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/sqlite-3.3.3-tcl-fix.patch
	#epatch "${FILESDIR}"/sqlite-3-test-fix-3.3.4.patch

	#epatch "${FILESDIR}"/sandbox-fix1.patch
	epatch "${FILESDIR}"/sandbox-fix2.patch

	# Fix broken tests that are not portable to 64bit arches
	epatch "${FILESDIR}"/sqlite-64bit-test-fix.patch
	epatch "${FILESDIR}"/sqlite-64bit-test-fix2.patch

	# Respect LDFLAGS wrt bug #156299
	sed -i -e 's/^LTLINK = .*/& $(LDFLAGS)/' Makefile.in

	elibtoolize
	epunt_cxx
}

src_compile() {
	local myconf="--enable-incore-db --enable-tempdb-in-ram --enable-cross-thread-connections"

	econf ${myconf} \
		$(use_enable debug) \
		$(use_enable !nothreadsafe threadsafe) \
		$(use_enable tcl) \
		|| die "econf failed"

	emake all || die "emake all failed"

	if use doc ; then
		emake doc || die "emake doc failed"
	fi
}

src_test() {
	if use tcl ; then
		if has userpriv ${FEATURES} ; then
			cd "${S}"
			if use debug ; then
				emake fulltest || die "some test failed"
			else
				emake test || die "some test failed"
			fi
		fi
	fi
}

src_install () {
	make \
		DESTDIR="${D}" \
		TCLLIBDIR="/usr/$(get_libdir)" \
		install \
		|| die "make install failed"

	newbin lemon lemon-${SLOT}

	dodoc README VERSION
	doman sqlite3.1

	use doc && dohtml doc/* art/*.gif
}

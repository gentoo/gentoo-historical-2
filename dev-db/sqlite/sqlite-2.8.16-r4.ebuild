# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlite/sqlite-2.8.16-r4.ebuild,v 1.17 2007/05/08 20:25:59 uberlord Exp $

inherit eutils alternatives toolchain-funcs

KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"

DESCRIPTION="SQLite: an SQL Database Engine in a C Library."
HOMEPAGE="http://www.sqlite.org/"
SRC_URI="http://www.sqlite.org/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
IUSE="doc nls tcl"

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

	use hppa && epatch "${FILESDIR}"/${PN}-2.8.15-alignement-fix.patch

	epatch "${FILESDIR}"/${P}-multilib.patch

	epunt_cxx

	if use nls ; then
		ENCODING=${ENCODING-"UTF8"}
	else
		ENCODING="ISO8859"
	fi

	sed -i -e "s:@@S@@:${S}:g" \
		-e "s:@@CC@@:$(tc-getCC):g" \
		-e "s:@@CFLAGS@@:${CFLAGS}:g" \
		-e "s:@@AR@@:$(tc-getAR):g" \
		-e "s:@@RANLIB@@:$(tc-getRANLIB):g" \
		-e "s:@@ENCODING@@:${ENCODING}:g" \
		"${S}"/Makefile.linux-gcc
}

src_compile() {
	local myconf="--enable-incore-db --enable-tempdb-in-ram"

	if ! use tcl ; then
		myconf="${myconf} --without-tcl"
	fi

	econf ${myconf} \
		$(use_enable nls utf8) \
		|| die "econf failed"

	emake all || die "emake all failed"

	if use doc ; then
		emake doc || die "emake doc failed"
	fi

	if use tcl ; then
		cp -P "${FILESDIR}"/maketcllib.sh "${S}"
		chmod +x ./maketcllib.sh
		./maketcllib.sh
	fi
}

src_test() {
	if use tcl ; then
		if has userpriv ${FEATURES} ; then
			elog "SQLite 2.x is known to have problems on 64 bit architectures."
			elog "If you observe segmentation faults please use 3.x instead!"

			cd "${S}"
			emake test || die "some test failed"
		fi
	fi
}

src_install () {
	dodir /usr/{bin,include,$(get_libdir)}

	make DESTDIR="${D}" install || die "make install failed"

	newbin lemon lemon-${SLOT}

	dodoc README VERSION
	doman sqlite.1

	use doc && dohtml doc/*.html doc/*.txt doc/*.png

	if use tcl ; then
		mkdir "${D}"/usr/$(get_libdir)/tclsqlite${PV}
		cp "${S}"/tclsqlite.so "${D}"/usr/$(get_libdir)/tclsqlite${PV}/
		cp "${S}"/pkgIndex.tcl "${D}"/usr/$(get_libdir)/tclsqlite${PV}/
	fi
}

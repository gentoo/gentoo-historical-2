# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlite/sqlite-2.8.16-r4.ebuild,v 1.7 2006/07/22 20:25:32 dertobi123 Exp $

inherit eutils toolchain-funcs alternatives


DESCRIPTION="SQLite: An SQL Database Engine in a C Library"
HOMEPAGE="http://www.sqlite.org/"
SRC_URI="http://www.sqlite.org/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~mips ppc ~ppc-macos ppc64 ~sh sparc ~x86 ~x86-fbsd"
IUSE="nls doc tcltk"

DEPEND="doc? ( dev-lang/tcl )
	tcltk? ( dev-lang/tcl )"

SOURCE="/usr/bin/lemon"
ALTERNATIVES="${SOURCE}-3 ${SOURCE}-0"

src_unpack() {
	# test
	if has test ${FEATURES}; then
		if ! has userpriv ${FEATURES}; then
			ewarn "The userpriv feature must be enabled to run tests."
			ewarn "The testsuite will be skipped."
	fi
		if ! use tcltk; then
			ewarn "The tcltk useflag must be enabled to run tests."
			ewarn "The testsuite will be skipped."
		fi
	fi

	unpack ${A} ; cd ${S}

	use hppa && epatch ${FILESDIR}/${PN}-2.8.15-alignement-fix.patch

	epatch ${FILESDIR}/${P}-multilib.patch

	epunt_cxx

	if use nls; then
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
		${S}/Makefile.linux-gcc
}

src_compile() {
	local myconf
	myconf="--enable-incore-db --enable-tempdb-in-ram"
	myconf="${myconf} `use_enable nls utf8`"

	if ! use tcltk; then
		myconf="${myconf} --without-tcl"
	fi

	econf ${myconf} || die
	emake all || die

	if use doc; then
		emake doc || die
	fi

	if use tcltk; then
		cp -P ${FILESDIR}/maketcllib.sh ${S}
		chmod +x ./maketcllib.sh
		./maketcllib.sh
	fi
}

src_test() {
	if use tcltk ; then
		if has userpriv ${FEATURES} ; then
			einfo "sqlite 2.x is known to have problems on 64 bit architectures"
			einfo "if you observe segmentation faults please use 3.x instead"

			cd ${S}
			emake test || die "some test failed"
		fi
	fi
}

src_install () {
	dodir /usr/{bin,include,$(get_libdir)}

	make DESTDIR="${D}" install || die

	newbin lemon lemon-${SLOT}

	dodoc README VERSION
	doman sqlite.1

	if use doc; then
		docinto html
		dohtml doc/*.html doc/*.txt doc/*.png
	fi

	if use tcltk; then
		mkdir ${D}/usr/$(get_libdir)/tclsqlite${PV}
		cp ${S}/tclsqlite.so ${D}/usr/$(get_libdir)/tclsqlite${PV}/
		cp ${S}/pkgIndex.tcl ${D}/usr/$(get_libdir)/tclsqlite${PV}/
	fi
}

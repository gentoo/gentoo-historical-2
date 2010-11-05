# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/yap/yap-6.0.4.ebuild,v 1.2 2010/11/05 22:01:24 keri Exp $

inherit eutils java-pkg-opt-2

PATCHSET_VER="0"

DESCRIPTION="YAP is a high-performance Prolog compiler."
HOMEPAGE="http://www.ncc.up.pt/~vsc/Yap/"
SRC_URI="http://www.ncc.up.pt/~vsc/Yap/yap-6.0.4.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc examples gmp java mpi mysql odbc readline static tk threads"

DEPEND="gmp? ( dev-libs/gmp )
	java? ( >=virtual/jdk-1.4 )
	mpi? ( virtual/mpi )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	readline? ( sys-libs/readline )
	doc? ( app-text/texi2html )"

RDEPEND="${DEPEND}
	tk? ( dev-lang/tk )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	epatch "${WORKDIR}"/${PV}
}

src_compile() {
	local myddas_conf
	if use mysql || use odbc; then
		myddas_conf="--enable-myddas \
				--enable-myddas-stats \
				--enable-myddas-top-level"
	else
		myddas_conf="--disable-myddas"
	fi

	econf \
		--libdir=/usr/$(get_libdir) \
		--enable-cut-c \
		$(use_enable !static dynamic-loading) \
		$(use_enable threads) \
		$(use_enable threads pthread-locking) \
		$(use_enable debug debug-yap) \
		$(use_enable debug low-level-tracer) \
		$(use_with gmp) \
		$(use_with readline) \
		$(use_with mpi) \
		$(use_with mpi mpe) \
		$(use_with java jpl) \
		${myddas_conf} \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc ; then
		emake html || die "emake html failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" -j1 install || die "make install failed."

	if use tk ; then
		exeinto /usr/bin
		doexe misc/tkyap
	fi

	dodoc changes*.html README

	if use doc ; then
		dodoc yap.html
	fi

	if use examples ; then
		docinto examples/chr
		dodoc packages/chr/Examples/*.{chr,pl}
		docinto examples/plunit
		dodoc packages/plunit/examples/*.pl
		if use java ; then
			docinto examples/jpl/prolog
			dodoc packages/jpl/examples/prolog/*.pl
			docinto examples/jpl/java
			dodoc packages/jpl/examples/java/*/*.java
		fi
		if use mpi ; then
			docinto examples/mpi
			dodoc library/mpi/examples/*.pl
		fi
	fi
}

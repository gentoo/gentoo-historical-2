# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tcldom/tcldom-3.0.ebuild,v 1.3 2006/06/03 19:56:32 matsuu Exp $

inherit eutils

DESCRIPTION="Document Object Model For Tcl"
HOMEPAGE="http://tclxml.sourceforge.net/tcldom.html"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"

IUSE="expat xml threads"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND=">=dev-lang/tcl-8.3.3
	>=dev-tcltk/tcllib-1.2
	~dev-tcltk/tclxml-3.0
	expat? ( dev-libs/expat )"

src_unpack() {
	unpack ${A}

	cd ${S}/library
	sed -e "s/@VERSION@/${PV}/" \
		-e "s/@Tcldom_LIB_FILE@@/UNSPECIFIED/" \
		< pkgIndex.tcl.in > pkgIndex.tcl
}

src_compile() {
	local myconf=""

	use threads && myconf="${myconf} --enable-threads"

	if use xml ; then
		cd ${S}/src-libxml2
		econf ${myconf} || die
		emake || die
	fi
	if use expat ; then
		cd ${S}/src
		econf ${myconf} || die
		emake || die
	fi
}

src_install() {
	insinto /usr/$(get_libdir)/${PN}${PV}
	doins library/*.tcl || die

	if use xml ; then
		cd ${S}/src-libxml2
		make DESTDIR=${D} install || die
	fi
	if use expat ; then
		cd ${S}/src
		make DESTDIR=${D} install || die
	fi

	cd ${S}
	dodoc ChangeLog LICENSE README RELNOTES
	docinto examples; dodoc examples/*
	dohtml docs/*.html
}

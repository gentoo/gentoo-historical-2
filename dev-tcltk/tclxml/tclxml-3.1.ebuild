# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclxml/tclxml-3.1.ebuild,v 1.2 2006/06/03 19:54:56 matsuu Exp $

inherit eutils

DESCRIPTION="Pure Tcl implementation of an XML parser."
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"

IUSE="expat threads xml"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"

DEPEND=">=dev-lang/tcl-8.2
	>=dev-tcltk/tcllib-1.2
	xml? ( >=dev-libs/libxml2-2.6.9 )
	expat? ( dev-libs/expat )
	!dev-tcltk/tclxml-expat"

MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-3_configure.patch
	epatch ${FILESDIR}/${PN}-3_include_path.patch
}

src_compile() {
	local myconf=""

	use threads && myconf="${myconf} --enable-threads"

	econf ${myconf} || die
	emake || die

	if use xml ; then
		cd ${S}/libxml2
		econf ${myconf} --with-Tclxml=.. || die
		emake || die
	fi
	if use expat ; then
		cd ${S}/expat
		econf ${myconf} --with-Tclxml=.. || die
		emake || die
	fi
}

src_install() {
	make DESTDIR=${D} install || die

	if use xml ; then
		cd ${S}/libxml2
		make DESTDIR=${D} install || die
	fi
	if use expat ; then
		cd ${S}/expat
		make DESTDIR=${D} install || die
	fi

	cd ${S}
	dodoc ANNOUNCE ChangeLog LICENSE README RELNOTES
	dohtml doc/*.html
}

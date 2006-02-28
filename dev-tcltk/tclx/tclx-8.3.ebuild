# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclx/tclx-8.3.ebuild,v 1.17 2006/02/28 00:16:50 vapier Exp $

inherit flag-o-matic eutils

IUSE="X"

DESCRIPTION="A set of extensions to TCL"
HOMEPAGE="http://www.neosoft.com/TclX/"
SRC_URI="ftp://ftp.slackware.com/pub/slackware/slackware-8.1/source/tcl/tclx/${PN}${PV}.tar.gz
	ftp://ftp.scriptics.com/pub/tcl/tcl8_3/tcl8.3.3.tar.gz
	ftp://ftp.scriptics.com/pub/tcl/tcl8_3/tk8.3.3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc alpha"

DEPEND="=dev-lang/tcl-8.3*
	X? ( =dev-lang/tk-8.3* )"

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${A} ; cd ${S}
	epatch ${FILESDIR}/${P}-makecfg.patch
	epatch ${FILESDIR}/${P}-argv.patch
	epatch ${FILESDIR}/${P}-varinit.patch
}

src_compile() {
	# we have to configure and build tcl before we can do tclx
	cd ${WORKDIR}/tcl8.3.3/unix
	econf || die "econf failed"
	emake CFLAGS="${CFLAGS}" || die "emake in tcl/unix failed"

	local myconf="--with-tcl=${WORKDIR}/tcl8.3.3/unix --enable-shared"

	if use X ; then
		# configure and build tk
		cd ${WORKDIR}/tk8.3.3/unix
		econf || die "econf failed"
		emake CFLAGS="${CFLAGS}" || die
		myconf="${myconf} --with-tk=${WORKDIR}/tk8.3.3/unix"
	else
		myconf="${myconf} --enable-tk=no"
	fi

	# configure and build tclx
	cd ${S}/unix
	econf ${myconf} || die "econf failed"
	make CFLAGS="${CFLAGS}" || die
}

src_install() {
	echo "installing tclx"
	cd ${S}/unix
	make INSTALL_ROOT=${D} install
	cd ${S}
	dodoc CHANGES README TO-DO doc/CONVERSION-NOTES
	doman doc/*.[n3]
}

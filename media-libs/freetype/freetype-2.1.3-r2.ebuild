# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freetype/freetype-2.1.3-r2.ebuild,v 1.7 2003/03/15 20:03:43 gerk Exp $

IUSE="doc"

inherit eutils flag-o-matic

FT_SMOOTH_VER="20021210"

SPV="`echo ${PV} | cut -d. -f1,2`"
S="${WORKDIR}/${P}"
DESCRIPTION="A high-quality and portable font engine"
SRC_URI="mirror://sourceforge/freetype/${P}.tar.bz2
	doc? ( mirror://sourceforge/${PN}/ftdocs-${PV}.tar.bz2 )
	smooth? ( http://www.cs.mcgill.ca/~dchest/xfthack/ft-smooth-${FT_SMOOTH_VER}.tar.gz )"
HOMEPAGE="http://www.freetype.org/"

SLOT="2"
LICENSE="FTL | GPL-2"
KEYWORDS="~x86 ppc ~sparc alpha ~hppa arm"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Patches fro better rendering quality.  Home page:
	#
	#  http://www.cs.mcgill.ca/~dchest/xfthack/
	#
	use smooth && epatch ${WORKDIR}/ft-smooth-${FT_SMOOTH_VER}/ft-all-together.diff

	# Slight Hint patch from Redhat
	epatch ${FILESDIR}/${SPV}/${P}-slighthint.patch
}

src_compile() {
	# Enable Bytecode Interpreter.
	append-flags "${CFLAGS} -DTT_CONFIG_OPTION_BYTECODE_INTERPRETER"
	
	make CFG="--host=${CHOST} --prefix=/usr" || die
	emake || die

	# Just a check to see if the Bytecode Interpreter was enabled ...
	if [ -z "`grep TT_Goto_CodeRange ${S}/objs/.libs/libfreetype.so`" ]
	then
		eerror "Could not enable Bytecode Interpreter!"
		die "Could not enable Bytecode Interpreter!"
	fi
}

src_install() {
	make prefix=${D}/usr install || die

	dodoc ChangeLog README 
	dodoc docs/{BUGS,BUILD,CHANGES,*.txt,PATENTS,readme.vms,TODO}

	use doc && dohtml -r docs/*
}

# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mono/mono-0.22.ebuild,v 1.1 2003/03/06 22:16:55 foser Exp $

inherit eutils mono

# they forgot PV in 0.22 mcs release doh :/
#MCS_P="mcs-${PV}"
MCS_P="mcs"
MCS_S=${WORKDIR}/${MCS_P}

IUSE=""
DESCRIPTION="Mono runtime and class librarier, a C# compiler/interpreter"
SRC_URI="http://www.go-mono.com/archive/${P}.tar.gz
	http://www.go-mono.com/archive/${MCS_P}-${PV}.tar.gz"
HOMEPAGE="http://www.go-mono.com/"

LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="~x86 -ppc"

DEPEND="virtual/glibc
	>=dev-libs/glib-2.0
	>=dev-libs/boehm-gc-6.1"

RDEPEND="${DEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}

	# add our own little in-place mcs script
	echo "${S}/mono/jit/mono ${S}/runtime/mcs.exe \"\$@\" " > ${S}/runtime/mcs
	chmod +x ${S}/runtime/mcs
}

src_compile() {
	econf --with-gc=boehm || die
	MAKEOPTS="-j1" emake || die "MONO compilation failure"

	cd ${MCS_S}
	PATH=${PATH}:${S}/runtime:${S}/mono/jit MONO_PATH=${MONO_PATH}:${S}/runtime emake -f makefile.gnu || die "MCS compilation failure"
}

src_install () {
	cd ${S}
	einstall || die

	dodoc AUTHORS ChangeLog COPYING.LIB NEWS README
	docinto docs 
	dodoc docs/*

	# now install our own compiled dlls
	cd ${MCS_S}
	einstall || die

	docinto mcs
	dodoc AUTHORS COPYING README* ChangeLog INSTALL.txt
	docinto mcs/docs
	dodoc docs/*.txt
}

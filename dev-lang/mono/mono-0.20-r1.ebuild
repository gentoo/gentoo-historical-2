# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mono/mono-0.20-r1.ebuild,v 1.1 2003/02/27 17:06:58 foser Exp $

inherit eutils mono

MCS_P="mcs-${PV}"
MCS_S=${WORKDIR}/${MCS_P}

IUSE=""
DESCRIPTION="Mono runtime and class librarier, a C# compiler/interpreter"
SRC_URI="http://www.go-mono.com/archive/${P}.tar.gz
	http://www.go-mono.com/archive/${MCS_P}.tar.gz"
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

	cd ${S}
	# patch to select a diff corlib rootdir 
	# needed for in-place mcs compilation
	# patch by foser <foser@gentoo.org>
	epatch ${FILESDIR}/${P}-unix_rootdir_env.patch

	# add our own little in-place mcs script
	echo "${S}/mono/jit/mono ${S}/runtime/mcs.exe \"\$@\" " > ${S}/runtime/mcs
	chmod +x ${S}/runtime/mcs
}

src_compile() {
	econf --with-gc=boehm || die
	MAKEOPTS="-j1" emake || die "MONO compilation failure"

	cd ${MCS_S}
	PATH=${PATH}:${S}/runtime:${S}/mono/jit MONO_ROOTDIR=${S}/runtime emake -f makefile.gnu || die "MCS compilation failure"
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

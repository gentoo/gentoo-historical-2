# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/ikvm/ikvm-0.14.0.1-r2.ebuild,v 1.1 2005/11/03 04:15:35 latexer Exp $

inherit mono multilib

CLASSPATH_P="classpath-0.15"

DESCRIPTION="Java VM for .NET"
HOMEPAGE="http://www.ikvm.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip
		ftp://ftp.gnu.org/gnu/classpath/${CLASSPATH_P}.tar.gz"
LICENSE="as-is"

SLOT="0"
S=${WORKDIR}/${PN}
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.1"
DEPEND="${RDEPEND}
		!dev-dotnet/ikvm-bin
		>=dev-java/jikes-1.21
		>=dev-dotnet/nant-0.85_rc2"

src_compile() {
	nant || die "ikvm build failed"
}

src_install() {
	dodir /usr/bin
	for exe in ikvm ikvmc ikvmstub;
	do
		sed -e "s:EXE:${exe}:" \
			-e "s:P:${PN}:" \
			${FILESDIR}/script-template \
			> ${D}/usr/bin/${exe}
		fperms +x /usr/bin/${exe}
	done

	dodir /usr/lib/pkgconfig
	sed -e "s:@VERSION@:${PV}:" \
		-e "s:@LIBDIR@:$(get_libdir):" \
		${FILESDIR}/ikvm.pc.in > ${D}/usr/lib/pkgconfig/ikvm.pc

	insinto /usr/$(get_libdir)/${PN}
	doins ${S}/bin/*
}

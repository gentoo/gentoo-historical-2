# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrkit/cdrkit-1.1.9.ebuild,v 1.3 2009/01/25 15:32:37 maekke Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://cdrkit.org/"
SRC_URI="http://cdrkit.org/releases/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc x86 ~x86-fbsd"
IUSE="hfs unicode kernel_linux kernel_FreeBSD"

RDEPEND="unicode? ( virtual/libiconv )
	kernel_linux? ( sys-libs/libcap )"
DEPEND=">=dev-util/cmake-2.4
	!app-cdr/cdrtools
	kernel_linux? ( sys-libs/libcap )
	unicode? ( virtual/libiconv )
	hfs? ( sys-apps/file )"

PROVIDE="virtual/cdrtools"

src_compile() {
	cmake \
		-DCMAKE_C_COMPILER=$(type -P $(tc-getCC)) \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		-DCMAKE_CXX_COMPILER=$(type -P $(tc-getCXX)) \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_BUILD_TYPE=None \
		-DCMAKE_INSTALL_PREFIX=/usr \
		|| die "cmake failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dosym wodim /usr/bin/cdrecord
	dosym genisoimage /usr/bin/mkisofs
	dosym icedax /usr/bin/cdda2wav
	dosym readom /usr/bin/readcd
	dosym wodim.1.bz2 /usr/share/man/man1/cdrecord.1.bz2
	dosym genisoimage.1.bz2 /usr/share/man/man1/mkisofs.1.bz2
	dosym icedax.1.bz2 /usr/share/man/man1/cdda2wav.1.bz2
	dosym readom.1.bz2 /usr/share/man/man1/readcd.1.bz2

	dodoc ABOUT Changelog FAQ FORK TODO doc/{PORTABILITY,WHY}

	for x in genisoimage plattforms wodim icedax; do
		docinto ${x}
		dodoc doc/${x}/*
	done

	insinto /etc
	newins wodim/wodim.dfl wodim.conf
	newins netscsid/netscsid.dfl netscsid.conf

	insinto /usr/include/scsilib
	doins include/*.h
	insinto /usr/include/scsilib/usal
	doins include/usal/*.h
	dosym usal /usr/include/scsilib/scg
}

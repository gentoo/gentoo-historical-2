# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fmod/fmod-3.74.ebuild,v 1.2 2004/11/09 01:01:02 mr_bones_ Exp $

MY_P="fmodapi${PV/.}linux"
S=${WORKDIR}/${MY_P}
DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org/"
SRC_URI="http://www.fmod.org/files/${MY_P}.tar.gz"

LICENSE="fmod"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND="virtual/libc"
RDEPEND="${DEPEND}
	 amd64? ( app-emulation/emul-linux-x86-baselibs )"

src_install() {
	dolib api/libfmod-${PV}.so
	dosym /usr/lib/libfmod-${PV}.so /usr/lib/libfmod.so

	insinto /usr/include
	doins api/inc/*

	insinto /usr/share/${PN}/media
	doins media/* || die "doins failed"
	cp -r samples "${D}/usr/share/${PN}/" || die "cp failed"

	dohtml -r documentation/*
	dodoc README.TXT documentation/Revision.txt
}

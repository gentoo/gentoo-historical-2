# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fmod/fmod-3.62.ebuild,v 1.1 2003/04/07 14:35:45 livewire Exp $

MY_P="fmodapi${PV/.}linux"
DESCRIPTION="music and sound effects library, and a sound processing system"
SRC_URI="http://www.fmod.org/files/${MY_P}.tar.gz"
HOMEPAGE="http://www.fmod.org/"

SLOT="0"
LICENSE="fmod"
KEYWORDS="x86 -ppc sparc -mips -alpha -arm -hppa"

S=${WORKDIR}/${MY_P}

src_install() {
	dolib api/libfmod-${PV}.so
	dosym /usr/lib/libfmod-${PV}.so /usr/lib/libfmod.so

	insinto /usr/include
	doins api/inc/*

	insinto /usr/share/${PN}/media
	doins media/*
	cp -r samples ${D}/usr/share/${PN}/

	dohtml -r documentation/*
	dodoc README.TXT documentation/Revision.txt
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/scratchbox-toolchain-cs2009q1-203sb1/scratchbox-toolchain-cs2009q1-203sb1-1.0.13.ebuild,v 1.1 2010/01/17 18:47:47 ayoy Exp $

SBOX_GROUP="sbox"

MY_PV="${PV}-2-i386"

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier."
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/stable/tarball/${PN/toolchain/toolchain-arm-linux}-${MY_PV}.tar.gz
	http://scratchbox.org/download/files/sbox-releases/stable/tarball/${PN/toolchain/toolchain-i486-linux}-${MY_PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="=dev-embedded/scratchbox-1.0*"

TARGET_DIR="/opt/scratchbox"

RESTRICT="strip"

S=${WORKDIR}/scratchbox

src_install() {
	dodir ${TARGET_DIR}
	cp -pRP * "${D}/${TARGET_DIR}"
}

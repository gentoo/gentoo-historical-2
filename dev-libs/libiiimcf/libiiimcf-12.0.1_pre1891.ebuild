# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libiiimcf/libiiimcf-12.0.1_pre1891.ebuild,v 1.2 2004/10/06 12:10:03 usata Exp $

inherit iiimf eutils

DESCRIPTION="A library to implement generic C interface for IIIM Client"

KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-libs/eimil-${PV}
	>=dev-libs/libiiimp-${PV}"
DEPEND="${RDEPEND}
	sys-devel/autoconf
	sys-devel/automake
	>=sys-apps/sed-4"

S="${WORKDIR}/${IMSDK}/lib/iiimcf"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:../EIMIL:/usr/lib:g" \
		-e "s:../iiimp:/usr/lib:g" Makefile* || die "sed failed"
	autoconf
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsolekalendar/konsolekalendar-3.5.10.ebuild,v 1.7 2009/07/12 13:10:57 armin76 Exp $

KMNAME=kdepim
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="A command line interface to KDE calendars"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=kde-base/libkcal-${PV}:${SLOT}
>=kde-base/libkdepim-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

KMCOPYLIB="libkcal libkcal
	libkdepim libkdepim"
KMEXTRACTONLY="	libkdepim/"
KMCOMPILEONLY="libkcal"

src_compile() {
	export DO_NOT_COMPILE="libkcal"
	kde-meta_src_compile myconf configure
	cd "${S}"/libkcal; emake htmlexportsettings.h
	kde-meta_src_compile make
}

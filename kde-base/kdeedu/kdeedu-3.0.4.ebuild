# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu/kdeedu-3.0.4.ebuild,v 1.6 2003/02/13 12:27:00 vapier Exp $
inherit kde-dist

IUSE=""
DESCRIPTION="KDE $PV - educational apps"
KEYWORDS="x86 ppc alpha"

src_unpack() {
	kde_src_unpack
	kde_sandbox_patch ${S}/klettres/klettres
}

src_compile() {

	kde_src_compile myconf configure

	# build fails with -fomit-frame-pointer optimization in kgeo
	kde_remove_flag kgeo -fomit-frame-pointer
	kde_remove_flag kgeo/kgeo -fomit-frame-pointer

	kde_src_compile make
}

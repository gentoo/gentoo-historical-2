# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/ktail/ktail-0.6.1.ebuild,v 1.11 2002/12/09 04:17:35 manson Exp $

inherit kde-base || die

need-kde 3

DESCRIPTION="ktail monitors multiple files and/or command output in one window."
SRC_URI="http://www.franken.de/users/duffy1/rjakob/${P}.tar.bz2"
HOMEPAGE="http://www.franken.de/users/duffy1/rjakob/"

IUSE=""
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc sparc "

src_compile() {
	kde_src_compile myconf configure
	cd $S/ktail
	mv Makefile Makefile.orig
	sed -e 's:kde_widgetdir = ${exec_prefix}/lib/kde3/plugins/designer:kde_widgetdir = ${kde_libs_prefix}/lib/kde3/plugins/designer:' Makefile.orig > Makefile
	cd ${S}
	kde_src_compile make
}

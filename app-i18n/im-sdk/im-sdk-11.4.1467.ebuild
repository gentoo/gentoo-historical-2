# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/im-sdk/im-sdk-11.4.1467.ebuild,v 1.2 2003/09/14 01:57:36 usata Exp $

inherit iiimf

IUSE=""

DESCRIPTION="Internet/Intranet Input Method Framework; the next generation of input method framework"

LICENSE="MIT X11 IBM"

DEPEND="=dev-libs/eimil-${PV}
	=dev-libs/libiiimcf-${PV}
	=dev-libs/libiiimp-${PV}
	=app-i18n/iiimcf-${PV}
	=app-i18n/iiimsf-${PV}
	=app-i18n/leif-${PV}"
RDEPEND="${DEPEND}
	=dev-libs/csconv-${PV}"

S="${WORKDIR}/${IMSDK}"

src_compile() {

	: # this is a meta package
}

src_install() {

	dodoc ChangeLog README
	dohtml -r doc/*
}

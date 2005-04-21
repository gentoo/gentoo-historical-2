# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/xbsql/xbsql-0.11.ebuild,v 1.6 2005/04/21 20:47:56 blubb Exp $

inherit base

DESCRIPTION="XBSQL: An SQL Wrapper for the XBase library"
HOMEPAGE="http://www.rekallrevealed.org/"
SRC_URI="http://www.rekallrevealed.org/packages/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc amd64"
IUSE="doc"

DEPEND="sys-devel/automake
	sys-devel/libtool
	=dev-db/xbase-2.0.0
	sys-libs/readline"
RDEPEND="=dev-db/xbase-2.0.0
	sys-libs/readline"

src_install() {
	base_src_install
	dodoc AUTHORS Announce COPYING ChangeLog INSTALL README TODO
	use doc && dohtml doc/*
}
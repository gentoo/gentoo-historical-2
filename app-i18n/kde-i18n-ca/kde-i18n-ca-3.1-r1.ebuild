# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kde-i18n-ca/kde-i18n-ca-3.1-r1.ebuild,v 1.3 2003/02/14 08:16:08 vapier Exp $

inherit eutils kde-i18n

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
}

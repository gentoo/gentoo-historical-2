# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/ebook-libgnomeui/ebook-libgnomeui-1.0.ebuild,v 1.1.1.1 2005/11/30 09:42:29 chriswhite Exp $

DESCRIPTION="libgnomeui 1.0  EBook."

EBOOKNAME="libgnomeui"
EBOOKVERSION="1.0"
NOVERSION="1"

inherit eutils ebook

src_unpack() {
	unpack libgnomeui.tar.gz
	cd ${S}
	epatch ${FILESDIR}/ebook-libgnome-book.devhelp.patch
}

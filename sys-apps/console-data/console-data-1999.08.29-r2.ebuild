# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/console-data/console-data-1999.08.29-r2.ebuild,v 1.3 2002/07/10 16:17:56 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Data (fonts, keymaps) for the consoletools package"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/keyboards/${P}.tar.gz"
HOMEPAGE="http://altern.org/ydirson/en/lct/data.html"
LICENSE="GPL-2"

src_compile() {

	./configure --host=${CHOST} \
		--prefix=/usr || die
	# do not use pmake
	make || die

}

src_install() {

	make DESTDIR=${D} install || die

	dodoc ChangeLog
	docinto txt
	dodoc doc/README.*
	docinto txt/fonts
	dodoc doc/fonts/*
	docinto txt/keymaps
	dodoc doc/keymaps/*
}


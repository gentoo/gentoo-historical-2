# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Taras Glek <taras.glek@home.com>
# $Header: /var/cvsroot/gentoo-x86/app-editors/scite/scite-1.4.5.ebuild,v 1.2 2002/05/23 06:50:08 seemant Exp $

S=${WORKDIR}/$PN/gtk
MY_PV=145
DESCRIPTION="A very powerful editor for programmers"
SRC_URI="http://www.scintilla.org/${PN}${MY_PV}.tgz" 
HOMEPAGE="http://www.scintilla.org"

DEPEND="virtual/glibc
	=x11-libs/gtk+-1.2*"

src_compile() {
	make -C ../../scintilla/gtk || die
	sed -e 's#usr/local#usr#g' -e 's#$(datadir)#${D}$(datadir)#g' \
		makefile > Makefile.good || die
	mv Makefile.good makefile
	sed -e 's#Exec=SciTE#Exec=scite#g' \
		-e 's#Type=Application#Type=Development#g' \
		SciTE.desktop > SciTE.desktop.good
	mv SciTE.desktop.good SciTE.desktop
	emake || die
}

src_install () {
	dodir /usr
	dodir /usr/bin
	dodir /usr/share
	dodir /usr/share/pixmaps
	dodir /usr/share/gnome/apps/Applications
	make prefix=${D}/usr install || die
	mv ${D}/usr/bin/SciTE ${D}/usr/bin/scite
	doman ../doc/scite.1
	dodoc ../License.txt ../readme

	if use gnome ;
	then
		# fix category (this is a developers tool)
		mv ${D}/usr/share/gnome/apps/Applications \
			${D}/usr/share/gnome/apps/Development
	else
		rm -rf ${D}/usr/share/gnome
	fi
}


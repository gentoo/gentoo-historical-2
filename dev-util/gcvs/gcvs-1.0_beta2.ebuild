# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Bruce A. Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/gcvs/gcvs-1.0_beta2.ebuild,v 1.1 2002/02/10 06:12:49 blocke Exp $

Z="gcvs-1.0b2"
S=${WORKDIR}/${Z}
DESCRIPTION="GUI frontend for CVS from the CVSGUI project"
SRC_URI="http://prdownloads.sourceforge.net/cvsgui/${Z}.tar.gz"
HOMEPAGE="http://cvsgui.sourceforge.net/"

DEPEND=">=x11-libs/gtk+-1.2.10 >=dev-lang/tcl-8.3.3 sys-devel/perl sys-devel/bison dev-util/glademm"
RDEPEND=">=x11-libs/gtk+-1.2.10 >=dev-lang/tcl-8.3.3 >=dev-util/cvs-1.11-r1"

src_compile() {

	./make_configure || die 
	./configure --prefix=/usr --host=${CHOST} || die

	# Ladies and Gentlemen... The following is pure evil...
	export HOME=${S}
	# Yes, thats right... the build process ends up trying to create
	# something in root's home directory... why?  they use glade,
	# a full blown gnome gui application to generate source code...

	# more evil... without this it builds its own copy of cvs
	# which of course installs itself on top of the real cvs package
	mv Makefile Makefile.old
	sed 's|cvsunix||g' Makefile.old > Makefile

	emake all || die

}

src_install () {

	make prefix=${D}/usr install

	# note: html docs ignored because they focus on the mac and windows
	# version and seem to be of questionable use with gcvs

	dodoc AUTHORS COPYING ChangeLog INSTALL README

	
}



# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gcvs/gcvs-1.0.ebuild,v 1.1 2004/10/17 20:22:52 liquidx Exp $

inherit eutils

MY_P=${P/eta/}
MY_P=${MY_P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="GUI frontend for CVS from the CVSGUI project"
SRC_URI="mirror://sourceforge/cvsgui/${MY_P}.tar.gz"
HOMEPAGE="http://cvsgui.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*
	>=dev-lang/tcl-8.3.3
	dev-lang/perl
	sys-devel/bison
	=dev-util/glademm-0.6*"

RDEPEND="${DEPEND}
	>=dev-util/cvs-1.11-r1"

src_unpack() {
	unpack ${A}
	cd ${S}
	aclocal && autoconf && automake || die
	epatch ${FILESDIR}/${P}-gentoo.patch || die
}

src_compile() {

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

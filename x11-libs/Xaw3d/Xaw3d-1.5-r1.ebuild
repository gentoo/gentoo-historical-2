# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/Xaw3d/Xaw3d-1.5-r1.ebuild,v 1.10 2003/02/13 16:54:38 vapier Exp $

# Ok, hopefully this will resolv the problem with the version of libXaw3d that
# gets created.
#
# The problem its seems, is that when X gets compiled, it determines (with the
# help of some very dark magic) what version libXaw.so it it should build (6.1 or
# 7.0).  Now, when compiling Xaw3d, it checks which version of Xaw was built, and
# then builds the same version of Xaw3d.
#
# Since this ebuild use the Makefile's "install" function, it "should" not be a
# problem anymore.
#
# Azarah.


IUSE=""

S=${WORKDIR}/xc/lib/Xaw3d
DESCRIPTION="the Xaw3d is a drop-in 3D replacement of the Xaw widget set
	     which comes with X. It is used e.g. by gv the ghostcript frontend."
# All full ftp.x.org mirrors can be added here.
SRC_URI="ftp://ftp.x.org/contrib/widgets/Xaw3d/R6.3/${P}.tar.gz
	 http://ibiblio.org/pub/X11/contrib/widgets/Xaw3d/R6.3/${P}.tar.gz"
HOMEPAGE="http://freshmeat.net/projects/xaw3d/"
LICENSE="X11"
SLOT="0"
KEYWORDS="x86 ppc sparc "

# There _might_ be something else, but I doubt it.
DEPEND="virtual/x11"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
    
	# For some reason it isn't automatically patched.
	# That's why I manually override the source_unpack function.
	patch -p0 <${FILESDIR}/Xaw3d-xfree86.diff || die
	patch -p0 <${FILESDIR}/Xaw3d-out-of-tree.diff || die

	# This adds more familiar scroll-bar look and feel for Emacs and
	# others <mkennedy@gentoo.org>
	mv Imakefile Imakefile~ \
		&& sed -e 's,#.*EXTRA_DEFINES,EXTRA_DEFINES,g' <Imakefile~ >Imakefile || die
}

src_compile() {
	# convoluted process for out-of-tree building
	mkdir ./X11
	cd ./X11 ; ln -sf ../../Xaw3d . ; cd ..
    
	xmkmf || die
	make includes || die
	make depend || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc README.XAW3D
}


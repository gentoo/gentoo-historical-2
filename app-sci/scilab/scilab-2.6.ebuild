# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Pierre-Henri Jondot <Pierre-Henri.Jondot@wanadoo.fr> with the help of Terje Kvernes
# $Header: /var/cvsroot/gentoo-x86/app-sci/scilab/scilab-2.6.ebuild,v 1.1 2002/04/29 05:51:08 rphillips Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Scilab is a scientific software package for numerical computations "
SRC_URI="ftp://ftp.inria.fr/INRIA/Projects/Meta2/Scilab/distributions/${P}.src.tar.gz"
HOMEPAGE="http://www-rocq.inria.fr/scilab/"

DEPEND="virtual/x11
		tcltk? ( dev-lang/tk )"

src_compile() {
	local myopts

	if [ "`use tcltk`" ]
	then
		myopts="--with-tk"
	fi

	./configure \
			--host=${CHOST} \
			--prefix=/usr \
			--infodir=/usr/share/info \
			--mandir=/usr/share/man \
			--sysconfdir=/etc \
			--localstatedir=/var \
			${myopts} || die "./configure failed"
	# HOME must be set to prevent writing to /root directory
	export HOME=/var/tmp/portage/${P}/work        
    make all || die
}

src_install () {
	BINDISTFILES="\
		${P}/.binary \
		${P}/.pvmd.conf \
		${P}/ACKNOWLEDGEMENTS \
        ${P}/CHANGES \
        ${P}/Makefile \
        ${P}/Makefile.OBJ \
        ${P}/Makefile.incl \
        ${P}/Makemex \
        ${P}/Path.incl \
        ${P}/README \
        ${P}/Version.incl \
        ${P}/configure \
        ${P}/libtool \
        ${P}/license.txt \
        ${P}/licence.txt \
        ${P}/scilab.quit \
        ${P}/scilab.star \
        ${P}/X11_defaults \
        ${P}/bin \
        ${P}/config \
        ${P}/contrib \
        ${P}/demos \
        ${P}/examples \
        ${P}/imp/NperiPos.ps \
        ${P}/imp/giffonts \
        ${P}/macros \
        ${P}/man \
        ${P}/maple \
        ${P}/pvm3/lib/pvm \
        ${P}/pvm3/lib/pvmd \
        ${P}/pvm3/lib/pvmtmparch \
        ${P}/pvm3/lib/pvmgetarch \
        ${P}/pvm3/lib/LINUX/pvmd3 \
        ${P}/pvm3/lib/LINUX/pvmgs \
        ${P}/routines/*.h \
        ${P}/routines/Make.lib \
        ${P}/routines/default/FCreate \
        ${P}/routines/default/Flist \
        ${P}/routines/default/README \
        ${P}/routines/default/fundef \
        ${P}/routines/default/*.c \
        ${P}/routines/default/*.f \
        ${P}/routines/graphics/Math.h \
        ${P}/routines/graphics/Graphics.h \
        ${P}/routines/interf/*.h \
        ${P}/routines/intersci/sparse.h \
        ${P}/routines/menusX/*.h \
        ${P}/routines/scicos/scicos.h \
        ${P}/routines/sun/*.h \
        ${P}/routines/xsci/*.h \
        ${P}/scripts \
        ${P}/tcl \
        ${P}/tests \
        ${P}/util"

	touch .binary
	strip bin/scilex
	(cd tests; make distclean)
	(cd examples; make distclean)
	dodir /usr/lib
	(cd ..; tar cf - ${BINDISTFILES} | (cd ${D}usr/lib; tar xf -))
	rm .binary

	dodir /usr/bin
	dosym /usr/lib/${P}/bin/scilab /usr/bin/scilab
	dosym /usr/lib/${P}/bin/intersci /usr/bin/intersci
	dosym /usr/lib/${P}/bin/intersci-n /usr/bin/intersci-n	
}

# the following is needed in order to create the startup scripts with
# the right paths
pkg_postinst () {
	(cd /usr/lib/${P}; make)
}

# but of course then, unmerge won't remove everything without the following
pkg_postrm () {
	rm /usr/lib/${P}/Path.incl
	rm -r /usr/lib/${P}/bin
	rm -r /usr/lib/${P}/util
	rmdir /usr/lib/${P} 
}

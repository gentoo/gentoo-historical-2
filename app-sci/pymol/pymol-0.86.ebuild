# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/pymol/pymol-0.86.ebuild,v 1.3 2003/03/11 20:41:30 george Exp $

IUSE=""

MY_PV=${PV/./_}
DESCRIPTION="A Python-extensible molecular graphics system."
SRC_URI="mirror://sourceforge/pymol/${PN}-${MY_PV}-src.tgz"
HOMEPAGE="http://pymol.sf.net"

LICENSE="PSF-2.2"
SLOT="0"
KEYWORDS="x86"

DEPEND="dev-lang/python
	dev-python/pmw
	dev-python/Numeric
	dev-lang/tk
	media-libs/libpng
	sys-libs/zlib
	media-libs/glut"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp setup/Rules.linux Rules.make
	patch -p0 < ${FILESDIR}/${PN}-gentoo.diff || die
}

src_compile() {
	CFLAGS="$CFLAGS -ffast-math"
	make || die
}

src_install() {
	local PYMOL_PATH=/usr/lib/pymol/${PV}
	dodir /usr/lib/pymol/${PV}
	cp -a modules ${D}/usr/lib/pymol/${PV}
	dodir /usr/bin
	cat <<-EOF > ${D}/usr/bin/pymol-${PV}
	#!/bin/sh
	export PYMOL_PATH=/usr/lib/pymol/${PV}
	export TCL_LIBRARY=/usr/lib/tcl8.3
	export PYTHONPATH=/usr/lib/pymol/${PV/modules}:\${PYTHONPATH}
	python /usr/lib/pymol/${PV}/modules/launch_pymol.py \$*
	EOF
	chmod 755 ${D}/usr/bin/pymol-${PV}
	dodoc README DEVELOPERS CHANGES
	dosym /usr/bin/pymol-${PV} /usr/bin/pymol
}

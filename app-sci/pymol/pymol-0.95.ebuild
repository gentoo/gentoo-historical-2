# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/pymol/pymol-0.95.ebuild,v 1.3 2004/06/24 22:15:39 agriffis Exp $

inherit distutils eutils

DESCRIPTION="A Python-extensible molecular graphics system."
HOMEPAGE="http://pymol.sourceforge.net/"
SRC_URI="mirror://sourceforge/pymol/${PN}-${PV/./_}-src.tgz"

LICENSE="PSF-2.2"
IUSE=""
SLOT="0"
KEYWORDS="~x86"

DEPEND="dev-lang/python
	dev-python/pmw
	dev-python/numeric
	dev-lang/tk
	media-libs/libpng
	sys-libs/zlib
	media-libs/glut"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/header_order.patch
	# Turn off splash screen.  Please do make a project contribution
	# if you are able though.
	[[ -n "$WANT_NOSPLASH" ]] && epatch ${FILESDIR}/nosplash-gentoo.patch
}

src_install() {
	distutils_src_install
	cd ${S}
	PYTHONPATH=$(find ${D}/usr/lib -type d -name site-packages) ${python} setup2.py

	local sedexp="s:${D%/}::g"
	sed -e ${sedexp} pymol.com > pymol
	exeinto /usr/bin
	doexe pymol
	dodoc DEVELOPERS CHANGES
	#install examples
	mv examples ${D}/usr/share/doc/${PF}
}

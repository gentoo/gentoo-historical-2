# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/nvidia-cg-toolkit/nvidia-cg-toolkit-2.1-r6.ebuild,v 1.3 2003/02/13 12:36:40 vapier Exp $

DESCRIPTION="nvidia's c graphics compiler toolkit"
HOMEPAGE="http://developer.nvidia.com/view.asp?IO=cg_toolkit"
SRC_URI="http://download.nvidia.com/developer/cg/Cg-Beta-2.1-6.tar.gz"
LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="~x86"
IUSE="glut nvidia-glx"
DEPEND="media-video/nvidia-glx
	virtual/glut"
S="${WORKDIR}/Cg-1.5.1-install/"

src_compile() {
	tar xfz Cg.tar.gz || die "Cannot prepare software."
}

src_install() {
	dobin usr/bin/cgc
	
	dolib usr/lib/*

	insinto /etc/env.d
	doins ${FILESDIR}/80cgc

	insinto /usr/include/Cg
	doins usr/include/Cg/*

	dodoc usr/local/Cg/MANIFEST usr/local/Cg/README \
	      usr/local/Cg/docs/Cg_Toolkit-1.5.pdf

	docinto examples
	dodoc   usr/local/Cg/examples/README.examples

	docinto examples/common
	dodoc   usr/local/Cg/examples/common/*

	docinto examples/runtime_ogl
	dodoc   usr/local/Cg/examples/runtime_ogl/*

	docinto examples/simple
	dodoc   usr/local/Cg/examples/simple/*

	#docinto include/Cg
	#dodoc   usr/local/Cg/include/GL/glext.h
}

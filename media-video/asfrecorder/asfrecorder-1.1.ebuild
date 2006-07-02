# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/asfrecorder/asfrecorder-1.1.ebuild,v 1.12 2006/07/02 13:53:35 pylon Exp $

inherit toolchain-funcs

MY_PN="${PN/asfr/ASFR}"
DESCRIPTION="ASFRecorder - Download Windows Media Streaming files"
HOMEPAGE="http://sourceforge.net/projects/asfrecorder/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="ppc ~ppc-macos x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_compile() {
	# There is a Makefile, but it only works for Cygwin, so we
	# only compile this single program.
	cd ${S}/source
	$(tc-getCC) -o asfrecorder ${CFLAGS} asfrecorder.c || die "Build failed"
}

src_install () {
	# Again, no makefiles, so just take what we want.
	dobin ${S}/source/asfrecorder
	dodoc ${S}/README.TXT
}

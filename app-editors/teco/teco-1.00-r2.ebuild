# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/teco/teco-1.00-r2.ebuild,v 1.4 2004/06/27 22:19:30 vapier Exp $

inherit ccc

DESCRIPTION="Classic TECO editor, Predecessor to EMACS"
HOMEPAGE="http://www.ibiblio.org/pub/linux/apps/editors/tty/ http://www.ibiblio.org/pub/academic/computer-science/history/pdp-11/teco"
SRC_URI="http://www.ibiblio.org/pub/linux/apps/editors/tty/teco.tar.gz
	doc? ( mirror://gentoo/tecolore.txt.gz
		mirror://gentoo/tech.txt.gz
		mirror://gentoo/teco.doc.gz
		mirror://gentoo/tecoprog.doc.gz )"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha x86"
IUSE="doc"

DEPEND="virtual/libc
	sys-libs/libtermcap-compat
	>=sys-apps/sed-4"
RDEPEND="virtual/libc
	sys-libs/libtermcap-compat"
PROVIDE="virtual/editor"

S=${WORKDIR}

src_compile() {
	# Remove hardcoded compiler and CFLAGS
	sed -i 's/CFLAGS = -O//' Makefile
	replace-cc-hardcode

	emake || die "compilation failed"

	echo
	size te; ls -l te
	echo
}

src_install() {
	dobin te
	dodoc sample.tecorc sample.tecorc2 READ.ME MANIFEST
	use doc && dodoc tecolore.txt tech.txt teco.doc tecoprog.doc
	doman te.1
}

pkg_postinst() {
	einfo "The TECO binary is called te."
	einfo "Sample configurations and documentation is available in /usr/share/doc/"
}

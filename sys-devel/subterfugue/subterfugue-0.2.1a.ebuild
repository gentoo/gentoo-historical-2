# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/subterfugue/subterfugue-0.2.1a.ebuild,v 1.1 2005/03/05 00:32:03 ciaranm Exp $

inherit distutils eutils

IUSE="gtk"

DESCRIPTION="strace meets expect"
SRC_URI="mirror://sourceforge/subterfugue/${P}.tgz"
HOMEPAGE="http://www.subterfugue.org/"
KEYWORDS="x86 amd64 -ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=dev-lang/python-2.0
	gtk? ( =x11-libs/gtk+-1.2*
		=dev-python/pygtk-0.6* )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# custom gentoo setup.py to get around <=python-2.1 requirement
	# - <liquidx@gentoo.org>
	cp ${FILESDIR}/${P}-setup.py ${S}/setup.py || die "copying custom setup.py failed"
	# patch for gcc33 - liquidx@gentoo.org
	EPATCH_OPTS="-d ${S}/modules" epatch ${FILESDIR}/${P}-gcc33.patch
}

src_compile() {
	# we use distutils to build python extensions (*.so) ONLY
	distutils_src_compile
	# manually python bytecode compile *.py
	make sf dsf compilepy || die "error compiling python modules"

	# remove trace of buildroot
	cp dsf dsf.orig
	sed -e "s:SUBTERFUGUE_ROOT=.*:SUBTERFUGUE_ROOT=/usr/lib/subterfugue/:" \
		< dsf.orig > sf
}

src_install() {
	# installs python extensions (*.so)
	mydoc="GNU-entry INTERNALS"
	distutils_src_install

	# installs python scripts (*.py?)
	insinto /usr/lib/subterfugue
	doins *.py *.py[co]
	insinto /usr/lib/subterfugue/tricks
	doins tricks/*.py tricks/*.py[co]

	# install binary and manpage
	dobin sf
	doman doc/sf.1
}

# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

S="${WORKDIR}/${P}"
DESCRIPTION="Pilot Resource Compiler"
HOMEPAGE="http://www.ardiri.com/index.php?redir=palm&cat=pilrc"
SRC_URI="http://www.ardiri.com/download/files/palm/pilrc_src.tgz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

src_compile() {
	cd ${S}
	pwd
	use gtk \
		|| myconf="${myconf} --disable-pilrcui"
	./configure ${myconf}
	make || die
}

src_install () {
	cd ${S}
	dobin pilrc
	if [ -e pilrcui ]
	then
		dobin pilrcui
	fi
}

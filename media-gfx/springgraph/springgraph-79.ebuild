# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/springgraph/springgraph-79.ebuild,v 1.4 2004/02/22 21:18:04 agriffis Exp $

DESCRIPTION="Generate spring graphs from graphviz input files"
HOMEPAGE="http://www.chaosreigns.com/code/springgraph"
SRC_FILENAME="${PN}.pl.${PV}"
SRC_URI="${HOMEPAGE}/dl/${SRC_FILENAME}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~hppa ~mips ~ppc ~sparc ia64 amd64"
IUSE=""
DEPEND=""
RDEPEND="dev-perl/GD"
S=${WORKDIR}/${P}

src_unpack() {
	# nothing to do
	:
}

src_compile() {
	# nothing to do
	:
}

src_install() {
	into /usr
	newbin ${DISTDIR}/${SRC_FILENAME} ${PN}
}

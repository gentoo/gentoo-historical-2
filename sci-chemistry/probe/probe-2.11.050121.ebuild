# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/probe/probe-2.11.050121.ebuild,v 1.1 2006/06/04 09:03:48 spyderous Exp $

inherit toolchain-funcs

MY_P="${PN}.${PV}"
DESCRIPTION="Evaluates atomic packing within or between molecules"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/probe.php"
SRC_URI="http://kinemage.biochem.duke.edu/ftpsite/pub/software/probe/${MY_P}.src.tgz"
LICENSE="richardson"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	# Respect CC
	sed -i \
		-e 's:cc:$(CC):g' \
		${S}/Makefile
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		MACHINEFLAGS="${LDFLAGS}" \
		|| die "make failed"
}

src_install() {
	dobin ${S}/probe
	dodoc ${S}/README*
}

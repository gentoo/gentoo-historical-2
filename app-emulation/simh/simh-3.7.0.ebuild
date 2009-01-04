# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/simh/simh-3.7.0.ebuild,v 1.4 2009/01/04 14:40:35 angelos Exp $

inherit eutils toolchain-funcs versionator

MY_P="${PN}v$(get_version_component_range 1)$(get_version_component_range 2)-$(get_version_component_range 3)"
DESCRIPTION="a simulator for historical computers such as Vax, PDP-11 etc.)"
HOMEPAGE="http://simh.trailing-edge.com/"
SRC_URI="http://simh.trailing-edge.com/sources/${MY_P}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

MAKEOPTS="USE_NETWORK=1 ${MAKEOPTS}"

src_unpack() {
	mkdir "${WORKDIR}/BIN"
	unpack ${A}

	# convert makefile from dos format to unix format
	edos2unix makefile

	sed -i -e "s:gcc:$(tc-getCC):" \
		-e "s: -g::" \
		-e "s:-O2:${CFLAGS}:" makefile
	epatch "${FILESDIR}/makefile.patch" \
		"${FILESDIR}"/${P}-asneeded.patch
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	cd "${S}/BIN"
	for BINFILE in *; do
		newbin ${BINFILE} "simh-${BINFILE}"
	done

	cd "${S}"
	dodir /usr/share/simh
	insinto /usr/share/simh
	doins VAX/*.bin
	dodoc *.txt */*.txt
}

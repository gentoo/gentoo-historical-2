# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/pmk/pmk-0.10.0.ebuild,v 1.1 2006/12/09 21:31:39 drizzt Exp $

inherit toolchain-funcs

DESCRIPTION="Aims to be an alternative to GNU autoconf"
HOMEPAGE="http://pmk.sourceforge.net/"
SRC_URI="mirror://sourceforge/pmk/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Remove executable stack
	cp detect_cpu_asm.s detect_cpu_asm.S
	cat >> detect_cpu_asm.S <<EOF
#ifdef __ELF__
.section .note.GNU-stack,"",%progbits
#endif
EOF
}

src_compile() {
	tc-export CC CPP AS
	./pmkcfg.sh -p /usr || die "Config failed"
	emake || die "Build failed"
}

src_install () {
	make DESTDIR="${D}" MANDIR=/usr/share/man install || die

	dodoc BUGS Changelog INSTALL LICENSE README STATUS TODO
}

pkg_postinst() {
	if [[ ! -f ${ROOT}etc/pmk/pmk.conf ]] ; then
		einfo
		einfo "${ROOT}etc/pmk/pmk.conf doesn't exist."
		einfo "Running pmksetup to generate an initial pmk.conf."
		einfo
		# create one with initial values
		${ROOT}usr/bin/pmksetup
		# run it again to reset PREFIX from /usr/local to /usr
		${ROOT}usr/bin/pmksetup -u PREFIX="/usr" &>/dev/null
	fi
}


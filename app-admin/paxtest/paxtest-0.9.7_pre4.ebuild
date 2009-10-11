# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/paxtest/paxtest-0.9.7_pre4.ebuild,v 1.4 2009/10/11 23:39:34 halcy0n Exp $

inherit eutils multilib

MY_P=${P/_/-}
DESCRIPTION="PaX regression test suite"
HOMEPAGE="http://www.adamantix.org/paxtest/"
#SRC_URI="http://www.adamantix.org/paxtest/${MY_P}.tar.gz"
SRC_URI="http://pax.grsecurity.net/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
# EI_PAX flags are not strip safe.
RESTRICT="strip"
S=${WORKDIR}/${MY_P}

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-apps/chpax-0.7
	sys-apps/paxctl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/Makefile.psm5 "${S}"/Makefile || die
	sed -i 's:-O2:${CFLAGS}:' "${S}"/Makefile
}

src_compile() {
	emake DESTDIR="${D}" BINDIR="${D}"/usr/bin RUNDIR=/usr/$(get_libdir)/paxtest || die
}

src_install() {
	make DESTDIR="${D}" BINDIR=/usr/bin RUNDIR=/usr/$(get_libdir)/paxtest install || die
	for doc in Changelog README ; do
		[[ -f ${doc} ]] && dodoc ${doc}
	done
}

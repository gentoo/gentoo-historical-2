# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ispell/ispell-3.3.02-r1.ebuild,v 1.11 2012/04/17 14:46:45 scarabeus Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

PATCH_VER="0.3"

DESCRIPTION="fast screen-oriented spelling checker"
HOMEPAGE="http://fmg-www.cs.ucla.edu/geoff/ispell.html"
SRC_URI="http://fmg-www.cs.ucla.edu/geoff/tars/${P}.tar.gz
		mirror://gentoo/${P}-gentoo-${PATCH_VER}.diff.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~mips ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	sys-apps/miscfiles
	>=sys-libs/ncurses-5.2
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${WORKDIR}"/${P}-gentoo-${PATCH_VER}.diff \
		"${FILESDIR}"/${P}-glibc-2.10.patch

	sed -e "s:GENTOO_LIBDIR:$(get_libdir):" -i local.h || die
	sed -e "s:\(^#define CC\).*:\1 \"$(tc-getCC)\":" -i local.h || die
	sed -e "s:\(^#define CFLAGS\).*:\1 \"${CFLAGS}\":" -i config.X || die
}

src_configure() {
	# Prepare config.sh for installation phase to avoid twice rebuild
	emake -j1 config.sh
	sed \
		-e "s:^\(BINDIR='\)\(.*\):\1${ED}\2:" \
		-e "s:^\(LIBDIR='\)\(.*\):\1${ED}\2:" \
		-e "s:^\(MAN1DIR='\)\(.*\):\1${ED}\2:" \
		-e "s:^\(MAN45DIR='\)\(.*\):\1${ED}\2:" \
			< config.sh > config.sh.install
}

src_compile() {
	emake -j1
}

src_install() {
	mv config.sh.install config.sh
	emake -j1 install
	dodoc CHANGES Contributors README WISHES
}

pkg_postinst() {
	echo
	ewarn "If you just updated from an older version of ${PN} you *have* to re-emerge"
	ewarn "all your dictionaries to avoid segmentation faults and other problems."
	echo
}

# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/distcc/distcc-1.1-r8.ebuild,v 1.1 2003/02/11 22:42:48 zwelch Exp $

inherit eutils

IUSE=""

HOMEPAGE="http://distcc.samba.org/"
SRC_URI="http://distcc.samba.org/ftp/distcc/distcc-${PV}.tar.bz2"
DESCRIPTION="a program to distribute compilation of C code across several machines on a network"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND=">=sys-apps/portage-2.0.46-r11
	>=sys-devel/gcc-config-1.3.1
	dev-libs/popt"

src_unpack() {
	unpack distcc-${PV}.tar.bz2
	cp -a distcc-${PV} distcc-${PV}.orig
	epatch "${FILESDIR}/wrapper-${PV}.patch"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install

	cd "${D}/usr/share/info" && rm -f distcc.info.gz

	docinto "../${PN}"
	dodoc "${S}/survey.txt"

	exeinto /etc/init.d
	newexe "${FILESDIR}/distccd.2" distccd

	# Search the PATH now that gcc doesn't live in /usr/bin
	#   ztw - this needs to be moved into an installed script so
	#    users/portage can re-run it after installing new compilers
	einfo "Scanning for compiler front-ends"
	dodir /usr/lib/distcc/bin
	diropts -m0755
	for a in gcc cc c++ g++ ${CHOST}-gcc ${CHOST}-c++ ${CHOST}-g++; do
		if [ -n "$(type -p ${a})" ]; then
			dosym /usr/bin/distcc /usr/lib/distcc/bin/${a}
		fi
	done
}

pkg_postinst() {
	einfo "To use distcc with **non-Portage** C compiling, add"
	einfo "/usr/lib/distcc/bin to your path before /usr/bin.  If you're"
	einfo "combining this with ccache, put the distcc dir AFTER ccache."
	einfo "Portage 2.0.26-r11+ will take advantage of distcc if you put"
	einfo "distcc into the FEATURES setting in make.conf (and define"
	einfo "DISTCC_HOSTS as well)."
}


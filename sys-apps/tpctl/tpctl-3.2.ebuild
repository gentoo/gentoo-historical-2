# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tpctl/tpctl-3.2.ebuild,v 1.4 2002/07/14 19:20:19 aliz Exp $

#transform P to match tarball versioning
MYPV=${PV/_beta/beta}
MYP="${PN}_${MYPV}"
KV=""

DESCRIPTION="Thinkpad system control user space programs"
SRC_URI="mirror://sourceforge/tpctl/${MYP}.tar.gz"
HOMEPAGE="http://tpctl.sourceforge.net/tpctlhome.htm"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="$DEPEND sys-apps/thinkpad ncurses? ( sys-libs/ncurses )"
RDEPEND="$RDEPEND sys-apps/thinkpad ncurses? ( sys-libs/ncurses ) perl? ( sys-devel/perl )"

src_compile() {

	emake -C lib || die "lib make failed"
	emake -C tpctl || die "tpctl make failed"
	if use ncurses > /dev/null; then
		emake -C ntpctl || die "ntpctl make failed"
	fi

	# Only for thinkpad models 760 and 765
	# build with:
	# $ USE=tpctlir emerge tpctl
	if use tpctlir > /dev/null; then
		emake -C tpctlir || die "tpctlir make failed"
	fi

}

src_install () {
	
	dodoc AUTHORS COPYING ChangeLog README SUPPORTED-MODELS TROUBLESHOOTING \
		VGA-MODES
	dolib lib/libsmapidev.so.1.0
	dobin tpctl/tpctl
	[ -e ntpctl/ntpctl ] && dobin ntpctl/ntpctl
	if use tpctlir > /dev/null &&  [ -e tpctlir/tpctlir ]; then
		mv tpctlir/README README.tpctlir
		dodoc README.tpctlir
		dobin tpctlir/tpctlir
	fi
	if use perl > /dev/null; then
		mv apmiser/README README.apmiser
		dodoc README.apmiser
		dosbin apmiser/apmiser
        exeinto /etc/init.d
		newexe ${FILESDIR}/apmiser.rc apmiser
	fi
	
}

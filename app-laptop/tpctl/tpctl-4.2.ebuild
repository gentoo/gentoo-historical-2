# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/tpctl/tpctl-4.2.ebuild,v 1.3 2004/06/28 02:37:53 vapier Exp $

#transform P to match tarball versioning
MYPV=${PV/_beta/beta}
MYP="${PN}_${MYPV}"

DESCRIPTION="Thinkpad system control user space programs"
HOMEPAGE="http://tpctl.sourceforge.net/tpctlhome.htm"
SRC_URI="mirror://sourceforge/tpctl/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE="ncurses tpctlir perl"

DEPEND=">=app-laptop/thinkpad-4.1
	ncurses? ( sys-libs/ncurses )"
RDEPEND="${DEPEND}
	perl? ( dev-lang/perl )"

src_compile() {
	emake -C lib || die "lib make failed"
	emake -C tpctl || die "tpctl make failed"
	if use ncurses ; then
		emake -C ntpctl || die "ntpctl make failed"
	fi

	# Only for thinkpad models 760 and 765
	# build with:
	# $ USE=tpctlir emerge tpctl
	if use tpctlir ; then
		emake -C tpctlir || die "tpctlir make failed"
	fi
}

src_install() {
	dodoc AUTHORS ChangeLog README SUPPORTED-MODELS TROUBLESHOOTING VGA-MODES
	dolib lib/libsmapidev.so.2.0
	dobin tpctl/tpctl
	[ -e ntpctl/ntpctl ] && dobin ntpctl/ntpctl
	if use tpctlir &&  [ -e tpctlir/tpctlir ]; then
		mv tpctlir/README README.tpctlir
		dodoc README.tpctlir
		dobin tpctlir/tpctlir
	fi
	if use perl ; then
		mv apmiser/README README.apmiser
		dodoc README.apmiser
		dosbin apmiser/apmiser
		exeinto /etc/init.d
		newexe ${FILESDIR}/apmiser.rc apmiser
	fi
}

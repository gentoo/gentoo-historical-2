# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gimps/gimps-27.6.ebuild,v 1.1 2012/04/27 11:57:45 jlec Exp $

EAPI=4

IUSE=""
DESCRIPTION="GIMPS - The Great Internet Mersenne Prime Search"
HOMEPAGE="http://mersenne.org/"
SRC_URI="amd64? ( ftp://mersenne.org/gimps/mprime${PV/./}-linux64.tar.gz )
	x86? ( ftp://mersenne.org/gimps/mprime${PV/./}.tar.gz )"

SLOT="0"
LICENSE="as-is"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="binchecks"

# Since there are no statically linked binaries for this version of mprime,
# and no static binaries for amd64 in general, we use the dynamically linked
# ones and try to cover the .so deps with the packages listed in RDEPEND.
DEPEND=""
RDEPEND="net-misc/curl"

S="${WORKDIR}"
I="/opt/gimps"
QA_EXECSTACK="opt/gimps/mprime"

src_install() {
	dodir ${I} /var/lib/gimps
	cp mprime "${D}/${I}"
	fperms a-w "${I}/mprime"
	fowners root:0 "${I}"
	fowners root:0 "${I}/mprime"

	dodoc license.txt readme.txt stress.txt whatsnew.txt undoc.txt

	newinitd "${FILESDIR}/${PN}-26.6-r1-init.d" gimps
	newconfd "${FILESDIR}/${PN}-25.6-conf.d" gimps
}

pkg_postinst() {
	echo
	einfo "You can use \`/etc/init.d/gimps start\` to start a GIMPS client in the"
	einfo "background at boot. Have a look at /etc/conf.d/gimps and check some"
	einfo "configuration options."
	einfo
	einfo "If you don't want to use the init script to start gimps, remember to"
	einfo "pass it an additional command line parameter specifying where the data"
	einfo "files are to be stored, e.g.:"
	einfo "   ${I}/mprime -w/var/lib/gimps"
	einfo
	einfo "GIMPS version 27.4 has issues with correct detection of physical and"
	einfo "logical CPUs on hyperthreaded Intel CPUs. If you determine that"
	einfo "GIMPS is not using the right CPUs on your PC use the"
	einfo "AffinityScramble2 option in your local.txt file (instructions in"
	einfo "/usr/share/doc/gimps-27.4/undoc.txt.bz2)."
	einfo "In a 4 core, 8 threads Core i7 \"AffinityScramble2=04152637\" works"
	einfo "best."
	einfo
	einfo "GIMPS version 27.4 is a beta version and it only offers improvements"
	einfo "for Intel CPUs with AVX instructions (Sandy Bridge and later). It"
	einfo "does _not_ work (at all) on AMD Bulldozer CPUs."
	einfo
	echo
}

pkg_postrm() {
	echo
	einfo "GIMPS data files were not removed."
	einfo "Remove them manually from /var/lib/gimps/"
	echo
}

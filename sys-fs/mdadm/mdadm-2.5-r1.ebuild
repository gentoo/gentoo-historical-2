# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mdadm/mdadm-2.5-r1.ebuild,v 1.1 2006/06/25 00:51:37 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="A useful tool for running RAID systems - it can be used as a replacement for the raidtools"
HOMEPAGE="http://cgi.cse.unsw.edu.au/~neilb/mdadm"
SRC_URI="mirror://kernel/linux/utils/raid/mdadm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="static ssl"

RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.0.51"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ssl-cleanup.patch
	epatch "${FILESDIR}"/${PN}-2.3.1-endian.patch #122269
	epatch "${FILESDIR}"/${PN}-1.9.0-dont-make-man.patch
	epatch "${FILESDIR}"/${PN}-2.4.1-syslog-updates.patch
	epatch "${FILESDIR}"/${PN}-2.5-build.patch #137823
	epatch "${FILESDIR}"/${PN}-2.5-pointer-magic.patch #137440
	use static && append-ldflags -static
	use ssl && export USE_SSL=1 || export USE_SSL=0
	sed -i -e 1iUSE_SSL=${USE_SSL} Makefile
}

src_compile() {
	emake \
		CWFLAGS="-Wall" \
		CXFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	exeinto /$(get_libdir)/rcscripts/addons
	doexe "${FILESDIR}"/raid-{start,stop}.sh || die "addon failed"
	dodoc INSTALL TODO "ANNOUNCE-${PV}"

	insinto /etc
	newins mdadm.conf-example mdadm.conf
	newinitd "${FILESDIR}"/mdadm.rc mdadm || die
	newconfd "${FILESDIR}"/mdadm.confd mdadm || die
}

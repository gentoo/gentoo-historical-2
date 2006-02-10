# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mdadm/mdadm-2.3.1.ebuild,v 1.2 2006/02/10 04:09:01 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="A useful tool for running RAID systems - it can be used as a replacement for the raidtools"
HOMEPAGE="http://cgi.cse.unsw.edu.au/~neilb/mdadm"
SRC_URI="mirror://kernel/linux/utils/raid/mdadm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~mips"
IUSE="static"

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.0.51"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-endian.patch #122269
	epatch "${FILESDIR}"/${PN}-1.9.0-dont-make-man.patch
	use static && append-ldflags -static
}

src_compile() {
	emake \
		CWFLAGS="-Wall" \
		CXFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	exeinto /$(get_libdir)/rcscripts/addons
	doexe "${FILESDIR}"/raid-{start,stop}.sh || die "addon failed"
	dodoc INSTALL TODO "ANNOUNCE-${PV}"

	insinto /etc
	newins mdadm.conf-example mdadm.conf
	newinitd "${FILESDIR}"/mdadm.rc mdadm
}

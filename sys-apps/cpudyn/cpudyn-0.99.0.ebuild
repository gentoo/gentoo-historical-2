# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cpudyn/cpudyn-0.99.0.ebuild,v 1.4 2004/06/24 22:01:04 agriffis Exp $

inherit eutils

DESCRIPTION="A daemon to control laptop power consumption via cpufreq and disk standby"
HOMEPAGE="http://mnm.uib.es/~gallir/${PN}/"
SRC_URI="http://mnm.uib.es/~gallir/${PN}/download/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc amd64"
IUSE=""
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	mkdir gentoo
	cp debian/cpudyn.conf gentoo
	cp ${FILESDIR}/cpudyn.init-0.99.0 gentoo/cpudyn.init
	epatch ${FILESDIR}/${PN}-0.99.0-init_conf_updates.patch
}

src_compile() {
	emake cpudynd || die "Compilation failed."
}

src_install() {
	into /
	exeinto /etc/init.d
	newexe gentoo/cpudyn.init cpudyn
	insinto /etc/conf.d
	newins gentoo/cpudyn.conf cpudyn

	into /usr
	doman cpudynd.8
	dosbin cpudynd
	dodoc INSTALL README VERSION changelog COPYING
	dohtml *.html
}

pkg_postinst() {
	einfo "Configuration file is /etc/conf.d/cpudyn."
}

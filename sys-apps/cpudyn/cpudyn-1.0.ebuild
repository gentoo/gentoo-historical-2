# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cpudyn/cpudyn-1.0.ebuild,v 1.1 2004/10/10 06:42:10 vapier Exp $

inherit eutils

DESCRIPTION="A daemon to control laptop power consumption via cpufreq and disk standby"
HOMEPAGE="http://mnm.uib.es/~gallir/${PN}/"
SRC_URI="http://mnm.uib.es/~gallir/${PN}/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}/debian
	epatch ${FILESDIR}/${PN}-0.99.0-init_conf_updates.patch
}

src_compile() {
	emake cpudynd || die "Compilation failed."
}

src_install() {
	dosbin cpudynd || die "dosbin"

	doman cpudynd.8
	dodoc INSTALL README VERSION changelog
	dohtml *.html

	exeinto /etc/init.d ; newexe ${FILESDIR}/cpudyn.init cpudyn
	insinto /etc/conf.d ; newins debian/cpudyn.conf cpudyn
}

pkg_postinst() {
	einfo "Configuration file is /etc/conf.d/cpudyn."
}

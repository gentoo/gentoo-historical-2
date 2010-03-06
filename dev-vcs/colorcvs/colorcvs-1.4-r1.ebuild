# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/colorcvs/colorcvs-1.4-r1.ebuild,v 1.1 2010/03/06 13:32:09 jlec Exp $

DESCRIPTION="A tool based on colorgcc to beautify cvs output"
HOMEPAGE="http://www.hakubi.us/colorcvs/"
SRC_URI="http://www.hakubi.us/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	dev-util/cvs"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix typo
	sed -i -e 's:compiler_pid:cvs_pid:' ${PN} || die "sed failed"
}

src_install() {
	insinto /etc/profile.d
	doins "${FILESDIR}/${PN}-profile.sh" || die "doins failed"

	dobin colorcvs || die "dobin failed"
	dodoc colorcvsrc-sample || die "dodoc failed"
}

pkg_postinst() {
	einfo
	einfo "An alias to colorcvs was installed for the cvs command."
	einfo "In order to immediately activate it do:"
	einfo "\tsource /etc/profile"
	einfo
}

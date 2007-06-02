# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/udept/udept-0.5.96.2.ebuild,v 1.5 2007/06/02 03:22:21 kumba Exp $

inherit bash-completion eutils

DESCRIPTION="A Portage analysis toolkit"
HOMEPAGE="http://catmur.co.uk/gentoo/udept"
SRC_URI="http://files.catmur.co.uk/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE=""

DEPEND="app-shells/bash
	sys-apps/portage"
RDEPEND="${DEPEND}"

BASH_COMPLETION_NAME="dep"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/bash-completion-install.diff"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog*
}

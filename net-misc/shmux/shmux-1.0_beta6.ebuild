# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/shmux/shmux-1.0_beta6.ebuild,v 1.2 2005/01/21 20:28:42 swegener Exp $

MY_P=${P/_beta/b}

DESCRIPTION="Program for executing the same command on many hosts in parallel"
HOMEPAGE="http://web.taranis.org/shmux/"
SRC_URI="http://web.taranis.org/${PN}/dist/${MY_P}.tgz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="pcre"

RDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	sys-apps/gawk"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf $(use_with pcre) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/shmux || die "dobin failed"
	doman shmux.1 || die "doman failed"
	dodoc CHANGES || die "dodoc failed"
}

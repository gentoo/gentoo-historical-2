# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sagan-rules/sagan-rules-22082011.ebuild,v 1.1 2011/08/31 08:30:15 maksbotan Exp $

EAPI=3

DESCRIPTION="Rules for Sagan log analyzer"
HOMEPAGE="http://sagan.softwink.com/"
SRC_URI="http://sagan.softwink.com/rules/sagan-rules-current.tar.gz ->
${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
PDEPEND="app-admin/sagan"

S=${WORKDIR}/sagan-rules

src_install() {
	insinto /etc/sagan-rules
	doins ./*.config
	doins ./*rules
}

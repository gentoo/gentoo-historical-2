# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kurso-de-esperanto/kurso-de-esperanto-3.0.ebuild,v 1.3 2004/06/24 21:49:28 agriffis Exp $

DESCRIPTION="multimedia computer program for teaching yourself Esperanto"
HOMEPAGE="http://www.cursodeesperanto.com.br/"
SRC_URI="http://www.cursodeesperanto.com.br/kurso.tar.gz"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="-* x86"

S=${WORKDIR}

src_install() {
	dodir /opt/kurso
	tar -zxf kurso-inst.tar.gz -C ${D}/opt/kurso/
	dobin ${FILESDIR}/kurso
	insinto /etc
	doins ${FILESDIR}/kurso.conf
}
